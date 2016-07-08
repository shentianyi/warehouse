module FileHandler
  module Excel
    class WrappageHandler<Base
      HEADERS=['容器编码', '容器简称', '容器描述', '操作']
      RELATION_HEADERS=['容器编码', '零件编码', '旧零件编码', '容量', '操作']
      STOCK_HEADERS=['容器编码', '容器数量', '发出容器地点', '接收容器地点', '操作']

      def self.import_stock(file, user)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg=validate_import_stock(file)

        if validate_msg.result
          begin
            NStorage.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                STOCK_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if ['容器编码', '发出容器地点', '接收容器地点', '操作'].include?(k)
                end

                part=Part.find_by_nr(row['容器编码'])
                send_l=Location.find_by_nr(row['发出容器地点']) unless row['发出容器地点'].blank?
                receive_l=Location.find_by_nr(row['接收容器地点'])

                params={}
                params[:toWh] = receive_l.default_whouse.id
                params[:toPosition] = receive_l.default_whouse.default_position.id
                params[:partNr] = part.id
                params[:qty] = row['容器数量']

                if row['操作']=='1'
                  WhouseService.new.enter_stock(params)
                elsif row['操作']=='2'
                  params[:fromWh] = send_l.default_whouse.id
                  params[:fromPosition] = send_l.default_whouse.default_position.id
                  WhouseService.new.move(params)
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

      def self.validate_import_stock file
        tmp_file=full_tmp_path(file.oriName)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row STOCK_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            STOCK_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k]=row[k].sub(/\.0/, '') if ['容器编码', '发出容器地点', '接收容器地点', '操作'].include?(k)
            end

            mssg = validate_import_stock_row(row)
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

      def self.validate_import_stock_row(row)
        msg = Message.new(contents: [])

        if row['容器编码'].blank?
          msg.contents << "容器编码不能为空"
        end

        if row['容器数量'].blank?
          msg.contents << "容器数量不能为空"
        end

        if row['接收容器地点'].blank?
          msg.contents << "接收容器地点不能为空"
        end

        if (l=Location.find_by_nr(row['接收容器地点'])).blank?
          msg.contents << "接收容器地点不存在"
        else
          if l.default_whouse.blank? || l.default_whouse.default_position.blank?
            msg.contents << "接收容器地点没有默认仓库和库位"
          end
        end

        if row['操作'].sub(/\.0/, '')=='2'
          if row['发出容器地点'].blank?
            msg.contents << "发出容器地点不能为空"
          else
            if (l=Location.find_by_nr(row['发出容器地点'])).blank?
              msg.contents << "发出容器地点不存在"
            else
              if l.default_whouse.blank? || l.default_whouse.default_position.blank?
                msg.contents << "发出容器地点没有默认仓库和库位"
              end
            end
          end
        elsif row['操作'].sub(/\.0/, '')=='1'

        else
          msg.contents << "操作编码不正确"
        end

        if Wrappage.find_by_nr(row['容器编码']).blank?
          msg.contents << "容器编码#{row['容器编码']}不存在"
        end

        if Part.find_by_nr(row['容器编码']).blank?
          msg.contents << "容器编码#{row['容器编码']}对应的零件不存在"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end


      def self.import_parts(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg=validate_import_parts(file)

        if validate_msg.result
          begin
            PartWrappage.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                RELATION_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if ['容器编码', '零件编码', '旧零件编码'].include?(k)
                end

                part=Part.find_by_nr(row['零件编码'])
                old_part=Part.find_by_nr(row['旧零件编码']) unless row['旧零件编码'].blank?
                wrappage=Wrappage.find_by_nr(row['容器编码'])

                if row['操作']=='update'
                  if pw= PartWrappage.where(
                      part_id: old_part.id, wrappage_id: wrappage.id).first
                    pw.update_attributes(part_id: part.id, capacity: row['容量'])
                  end
                elsif row['操作']=='delete'
                  if pw= PartWrappage.where(
                      part_id: part.id, wrappage_id: wrappage.id).first
                    pw.destroy
                  end
                elsif PartWrappage.where(
                    part_id: part.id, wrappage_id: wrappage.id).first.blank?

                  PartWrappage.create(
                      part_id: part.id,
                      wrappage_id: wrappage.id,
                      capacity: row['容量']
                  )
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

      def self.validate_import_parts file
        tmp_file=full_tmp_path(file.oriName)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row RELATION_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            RELATION_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              row[k]=row[k].sub(/\.0/, '') if ['容器编码', '零件编码', '旧零件编码'].include?(k)
            end

            mssg = validate_import_parts_row(row)
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

      def self.validate_import_parts_row(row)
        msg = Message.new(contents: [])

        if row['容器编码'].blank?
          msg.contents << "容器编码不能为空"
        end

        if row['零件编码'].blank?
          msg.contents << "零件编码不能为空"
        end

        if row['容量'].blank?
          msg.contents << "容量不能为空"
        end

        if (part=Part.find_by_nr(row['零件编码'])).blank?
          msg.contents << "零件编码#{row['零件编码']}不存在"
        end

        unless row['旧零件编码'].blank?
          if Part.find_by_nr(row['旧零件编码']).blank?
            msg.contents << "旧零件编码#{row['旧零件编码']}不存在"
          end
        end

        if (wrappage=Wrappage.find_by_nr(row['容器编码'])).blank?
          msg.contents << "容器编码#{row['容器编码']}不存在"
        end

        if row['操作']=='update'
          if row['旧零件编码'].blank?
            msg.contents << "旧零件编码不能为空"
          end
        elsif row['操作']=='delete'
        else
          if part && PartWrappage.find_by_part_id(part.id)
            msg.contents << "该零件已有对应关系"
          end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end


      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg=validate_import(file)

        if validate_msg.result
          begin
            Wrappage.transaction do
              2.upto(book.last_row) do |line|
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  row[k]=row[k].sub(/\.0/, '') if k=='容器编码'
                end

                if row['操作']=='new'
                  Wrappage.create(nr: row['容器编码'], name: row['容器简称'], desc: row['容器描述'])
                elsif row['操作']=='delete'
                  if w=Wrappage.find_by_nr(row['容器编码'])
                    w.destroy
                  end
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
              row[k]=row[k].sub(/\.0/, '') if k=='容器编码'
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

        if row['容器编码'].blank?
          msg.contents << "容器编码不能为空"
        end

        if Wrappage.find_by_nr(row['容器编码'])
          msg.contents << "容器编码#{row['容器编码']}已经存在"
        end

        if Part.find_by_nr(row['容器编码'])
          msg.contents << "零件号#{row['容器编码']}已经存在"
        end

        unless ['new', 'delete'].include?(row['操作'])
          msg.contents << "操作编码为：new 或者 delete"
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end


    end
  end
end