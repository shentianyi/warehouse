module FileHandler
  module Excel
    class ScrapListItemHandler<Base
      HEADERS=[
          '源仓库','目的仓库','创建者','零件号','总成号','数量','单位','原因','登记人','登记时间'
      ]

      def self.import(file,scrap_list_id)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg=validate_import(file)

        if validate_msg.result
          #validate file
          begin
            ScrapListItem.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if k=='零件号'
                end

                ScrapListItem.create({scrap_list_id:scrap_list_id,
                                      part_id:row['零件号'],
                                      product_id:row['总成号'],
                                      quantity:row['数量'],
                                      IU:row['单位'],
                                      reason:row['原因'],
                                      name:row['登记人'],
                                      time:row['登记时间'].to_time.utc})
              end
            end
            msg.result = true
            msg.content = "导入报废单数据成功"
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

      def self.validate_row(row,line)
        msg = Message.new(contents: [])

        src_warehouse = Whouse.find_by_name(row['源仓库'])
        unless src_warehouse
          msg.contents << "源仓库:#{row['源仓库']} 不存在!"
        end

        dse_warehouse = Whouse.find_by_name(row['目的仓库'])
        unless dse_warehouse
          msg.contents << "目的仓库:#{row['目的仓库']} 不存在!"
        end

        # builder = User.find_by_name(row['创建者'])
        # unless builder
        #   msg.contents << "创建者:#{row['创建者']} not found!"
        # end
        #
        # builder = User.find_by_name(row['登记人'])
        # unless builder
        #   msg.contents << "登记人:#{row['登记人']} not found!"
        # end

        part_id = Part.find_by_id(row['零件号'])
        unless part_id
          msg.contents << "零件号:#{row['零件号']} 不存在!"
        end

        unless row['数量'].to_f > 0
          msg.contents << "数量: #{row['数量']} should not be 0!"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end
    end
  end
end