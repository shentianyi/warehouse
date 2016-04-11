module FileHandler
  module Excel
    class PartClientHandler<Base
      HEADERS=['零件号', '客户零件号', 'Operator']

      def self.import(file, tenant_id)
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
                  row[k]=row[k].sub(/\.0/, '') if k=='零件号' || k=='客户零件号'
                end

                part=Part.find_by_nr(row['零件号'])

                if row['Operator']=='update'
                  if pc= PartClient.where(
                      part_id: part.id, client_tenant_id: tenant_id).first
                    pc.update_attributes(client_part_nr: row['客户零件号'])
                  end
                elsif row['Operator']=='delete'
                  if pc= PartClient.where(
                      part_id: part.id, client_part_nr: row['客户零件号'], client_tenant_id: tenant_id).first
                    pc.destroy
                  end
                elsif PartClient.where(
                    # part_id: part.id, client_part_nr: row['客户零件号'], client_tenant_id: tenant_id).first.blank?
                    part_id: part.id, client_tenant_id: tenant_id).first.blank?

                  PartClient.create(
                      part_id: part.id,
                      client_part_nr: row['客户零件号'],
                      client_tenant_id: tenant_id)
                end
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
              row[k]=row[k].sub(/\.0/, '') if k=='零件号' || k=='客户零件号'
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

        if row['客户零件号'].blank?
          msg.contents << "客户零件号不为空"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end


    end
  end
end