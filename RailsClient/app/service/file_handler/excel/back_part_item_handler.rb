module FileHandler
  module Excel
    class BackPartItemHandler<Base
      HEADERS=[
          '零件号', '数量', '仓库号', '库位号', '退货原因', '样品', '备注'
      ]

      def self.import(file, id)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg=validate_import(file)

        if validate_msg.result
          #validate file
          begin
            BackPartItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if ['零件号', '仓库号', '库位号'].include?(k)
                end

                part=Part.find_by_nr(row['零件号'])
                whouse=Whouse.find_by_nr(row['仓库号'])
                position=Position.find_by_nr(row['库位号'])
                params={
                    back_part_id: id,
                    whouse_id: whouse.id,
                    part_id: part.id,
                    position_id: position.id,
                    qty: row['数量'].to_f,
                    back_reason: row['退货原因'],
                    has_sample: row['样品'].present? ? (row['需要转换']=='Y') : false,
                    remark: row['备注']
                }
                BackPartItem.create(params)
              end
            end
            msg.result = true
            msg.content = "导入退货单数据成功"
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
              row[k]=row[k].sub(/\.0/, '') if ['零件号', '仓库号', '库位号'].include?(k)
            end

            mssg = validate_row(row)
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

      def self.validate_row(row)
        msg = Message.new(contents: [])

        position = Position.find_by(nr: row['库位号'])
        unless position
          msg.contents << "库位号:#{row['库位号']} 不存在!"
        end

        src_warehouse = Whouse.find_by_nr(row['仓库号'])
        unless src_warehouse
          msg.contents << "仓库号:#{row['仓库号']} 不存在!"
        end

        part_id = Part.find_by_nr(row['零件号'])
        unless part_id
          msg.contents << "零件号:#{row['零件号']} 不存在!"
        end

        unless row['数量'].to_f > 0
          msg.contents << "数量: #{row['数量']} 不可以 0!"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end


    end
  end
end