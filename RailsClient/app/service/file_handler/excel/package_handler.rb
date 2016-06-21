module FileHandler
  module Excel
    class PackageHandler<Base
      HEADERS=['唯一码', '零件号', '数量', '备注', '操作']

      def self.import(file, user)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg=validate_import(file)

        if validate_msg.result
          begin
            PartClient.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if k=='零件号' || k=='唯一码'
                end

                part=Part.find_by_nr(row['零件号'])
                # package=Package.find_by_id(row['唯一码'])
                #
                # if row['操作']=='update'
                #   package.update_attributes(part_id: part.id, quantity: row['数量'], remark: row['备注'])
                # elsif row['操作']=='delete'
                #   package.destroy
                # elsif package.blank?
                  package=Package.new({
                                          id: row['唯一码'],
                                          part_id: part.id,
                                          part_id_display: part.id,
                                          quantity: row['数量'],
                                          quantity_display: row['数量'],
                                          # custom_fifo_time: params[:fifo_time],
                                          # fifo_time_display: params[:fifo_time_display]
                                          remark: row['备注']
                                      })
                  package.user_id=user.id
                  package.location_id=user.location_id

                  if package.save
                    lc=package.logistics_containers.build(source_location_id: package.location_id, user_id: package.user_id, remark: row['备注'])
                    lc.save
                    lc.package=package
                  end
                # end
              end
            end
            msg.result = true
            msg.content = "导入数据成功"
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
              row[k]=row[k].sub(/\.0/, '') if k=='零件号' || k=='唯一码'
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

        unless Part.find_by_nr(row['零件号'])
          msg.contents << "零件号不存在"
        end

        if Package.exists?(row['唯一码'])
          msg.contents << "唯一码已存在"
        end

        if row['数量'].to_i <= 0
          msg.contents << "数量：#{row['数量']}不合法"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end


    end
  end
end