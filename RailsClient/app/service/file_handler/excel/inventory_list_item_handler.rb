module FileHandler
  module Excel
    class InventoryListItemHandler<Base
      HEADERS=[
          '仓库号', '零件号', 'FIFO', '数量', '库位号', '包装号', '唯一码', '原材料/半成品/成品标记', '需要转换'
      ]
      DETAIL_HEADERS=[
          'No.', '仓库号', '零件号', 'FIFO', '数量', '原数量', '盘点库位号', '包装号', '唯一号', '目前仓库', '目前库位', '原材料/半成品/成品标记', '原材料线/非线标记', '需要转换','是否已入库', '创建人', '是否在库存', '所属清单'
      ]

      TOTAL_HEADERS=[
          '仓库号', '零件号', 'FIFO', '数量', '原材料/半成品/成品标记', '原材料线/非线标记'
      ]

      def self.import(file, inventory_list_id)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg=validate_import(file)

        if validate_msg.result
          #validate file
          begin
            InventoryListItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if k=='零件号'
                end
                # if row['数量'].to_f > 0
                  params={inventory_list_id: inventory_list_id,
                          whouse_id: row['仓库号'],
                          part_id: row['零件号'],
                          fifo: row['FIFO'].present? ? row['FIFO'].to_time.utc : nil,
                          origin_qty: row['数量'].to_f,
                          position: row['库位号'],
                          package_id: row['包装号'],
                          unique_id: row['唯一码'],
                          part_form_mark: row['原材料/半成品/成品标记'],
                          need_convert: row['需要转换'].present? ? (row['需要转换']=='Y') : false
                  }
                  InventoryListItem.new_item(params)
                # end
              end
            end
            msg.result = true
            msg.content = "导入盘点单数据成功"
          rescue => e
            puts e.backtrace
            msg.result = false
            msg.content = e.message
          end
        else
          msg.result = false
          msg.content = validate_msg.content
        end
        msg
      end

      def self.export_total(items)
        msg=Message.new
        tmp_file=full_tmp_path('盘点汇总清单.xlsx')
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row TOTAL_HEADERS
          items.all.each do |inventory_list_item|
            sheet.add_row [
                              inventory_list_item.whouse_id,
                              inventory_list_item.part_id,
                              inventory_list_item.fifo_export_display,
                              inventory_list_item.qty,
                              inventory_list_item.part_form_mark,
                              inventory_list_item.part_wire_mark
                          ], types: [:string, :string, :string, :string, :string, :string]

          end
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)

        msg.result =true
        msg.content =tmp_file
        msg
      end

      def self.export_detail(items)
        msg=Message.new
        tmp_file=full_tmp_path('盘点详细清单.xlsx')
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row DETAIL_HEADERS
          items.all.each_with_index do |inventory_list_item, i|
            sheet.add_row [
                              i+1,
                              inventory_list_item.whouse_id,
                              inventory_list_item.part_id,
                              inventory_list_item.fifo_export_display,
                              inventory_list_item.qty,
                              inventory_list_item.origin_qty,
                              inventory_list_item.position,
                              inventory_list_item.package_id,
                              inventory_list_item.unique_id,
                              inventory_list_item.current_whouse,
                              inventory_list_item.current_position,
                              inventory_list_item.part_form_mark,
                              inventory_list_item.part_wire_mark,
                              inventory_list_item.need_convert_display,
                              inventory_list_item.in_stored_display,
                              inventory_list_item.user_id,
                              inventory_list_item.in_store_display,
                              inventory_list_item.inventory_list.name
                          ], types: [:string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string]

          end
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)

        msg.result =true
        msg.content =tmp_file
        msg
      end


      def self.validate_import file
        tmp_file=full_tmp_path(file.oriName)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k]=row[k].sub(/\.0/, '') if k=='零件号'
            end

            mssg = validate_row(row, line)
            if mssg.result
              sheet.add_row row.values
            else
              if msg.result
                msg.result = false
                msg.content = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              sheet.add_row row.values<<mssg.content
            end
          end
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)
        msg
      end

      def self.validate_row(row, line)
        msg = Message.new(contents: [])

        src_warehouse = Whouse.find_by_name(row['仓库号'])
        unless src_warehouse
          msg.contents << "仓库号:#{row['仓库号']} 不存在!"
        end

        part_id = Part.find_by_id(row['零件号'])
        unless part_id
          msg.contents << "零件号:#{row['零件号']} 不存在!"
        end
        #
        # unless row['数量'].to_f > 0
        #   msg.contents << "数量: #{row['数量']} 不可以 0!"
        # end

        if row['FIFO'].present?
          begin
            row['FIFO'].to_time
          rescue => e
            msg.contents << "FIFO: #{row['FIFO']} 错误!"
          end
        end
        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end
    end
  end
end