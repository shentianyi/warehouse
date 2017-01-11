module FileHandler
  module Excel
    class DockPointHandler<Base
      HEADERS=[
          :nr, :desc, :operator
      ]

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          # begin
          DockPoint.transaction do
            2.upto(book.last_row) do |line|
              row = {}
              HEADERS.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip
                row[k]=row[k].sub(/\.0/, '') if [:nr].include?(k)
              end

              dock_point=DockPoint.find_by_nr(row[:nr])
              if ['update', 'UPDATE'].include?(row[:operator])
                dock_point.update(row.except(:operator))
              elsif ['delete', 'DELETE'].include?(row[:operator])
                dock_point.destroy
              else
                dock_point = DockPoint.new(row.except(:operator))
                unless dock_point.save
                  puts dock_point.errors.to_json
                  raise dock_point.errors.to_json
                end
              end

            end
          end
          msg.result = true
          msg.content = "导入停靠点信息成功！"
          # rescue => e
          #  puts e.backtrace
          # msg.result = false
          # msg.content = e.message
          # end
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
              row[k]=row[k].sub(/\.0/, '') if [:nr].include?(k)
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

        if row[:nr].blank?
          msg.contents<<"停靠点编号不可为空"
        else
          if ['update', 'UPDATE', 'DELETE', 'delete'].include?(row[:operator])
            if DockPoint.find_by_nr(row[:nr]).blank?
              msg.contents<<"停靠点编号:#{row[:nr]}不存在"
            end
          else
            if DockPoint.find_by_nr(row[:nr])
              msg.contents<<"停靠点编号:#{row[:nr]}已存在"
            end
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
