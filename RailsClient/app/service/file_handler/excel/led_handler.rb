module FileHandler
  module Excel
    class LedHandler<Base
      HEADERS=[
          :nr, :name, :modem_id, :new_modem_id, :position_id, :order_box_id, :order_car_id, :current_state, :led_display, :is_valid, :operator
      ]

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          #validate file
          # begin
          Led.transaction do
            2.upto(book.last_row) do |line|
              row = {}
              HEADERS.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip
                row[k]=row[k].sub(/\.0/, '') if [:name, :id, :nr].include?(k)
              end
              row[:modem_id] = Modem.find_by_ip(row[:modem_id]).id unless row[:modem_id].blank?
              row[:position_id] = Position.find_by_detail(row[:position_id]).id unless row[:position_id].blank?
              row[:order_box_id] = OrderBox.find_by_nr(row[:order_box_id]).id unless row[:order_box_id].blank?
              row[:order_car_id] = OrderCar.find_by_nr(row[:order_car_id]).id unless row[:order_car_id].blank?
              row[:is_valid] = row[:is_valid]=='Y' ? true : false

              led=Led.where(nr: row[:nr], modem_id: row[:modem_id]).first
              if ['update', 'UPDATE'].include?(row[:operator])
                row[:modem_id] = Modem.find_by_ip(row[:new_modem_id]).id unless row[:new_modem_id].blank?
                led.update(row.except(:operator, :new_modem_id))
              elsif ['delete', 'DELETE'].include?(row[:operator])
                led.destroy
              else
                led = Led.new(row.except(:operator, :new_modem_id))
                unless led.save
                  puts led.errors.to_json
                  raise led.errors.to_json
                end
              end

            end
          end
          msg.result = true
          msg.content = "导入LED信息成功！"
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
              row[k]=row[k].sub(/\.0/, '') if [:nr, :name].include?(k)
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

        led=nil
        if row[:nr].blank? || row[:modem_id].blank?
          msg.contents<<"LED编号和控制器IP不可为空"
        else
          led = Led.joins(:modem).where(nr: row[:nr]).where(modems: {ip: row[:modem_id]}).first
          if ['update', 'UPDATE', 'DELETE', 'delete'].include?(row[:operator])
            if (led = Led.joins(:modem).where(nr: row[:nr]).where(modems: {ip: row[:modem_id]}).first).blank?
              msg.contents<<"LED->编号:#{row[:nr]}/控制器IP:#{row[:modem_id]}不存在"
            end
          else
            if led.present?
              msg.contents<<"LED->编号:#{row[:nr]}/控制器IP:#{row[:modem_id]}已存在"
            end
          end
        end

        unless row[:modem_id].blank?
          unless Modem.find_by_ip(row[:modem_id])
            msg.contents<<"控制器IP:#{row[:modem_id]}不存在"
          end
        end
        
        unless row[:new_modem_id].blank?
          if ['update', 'UPDATE'].include?(row[:operator])
            unless Modem.find_by_ip(row[:new_modem_id])
              msg.contents<<"控制器IP:#{row[:new_modem_id]}不存在"
            end
          end
        end

        unless row[:position_id].blank?
          unless Position.find_by_detail(row[:position_id])
            msg.contents<<"库位号:#{row[:position_id]}不存在"
          end
        end

        unless row[:order_box_id].blank?
          unless OrderBox.find_by_nr(row[:order_box_id])
            msg.contents<<"料盒:#{row[:order_box_id]}不存在"
          end
        end

        unless row[:order_car_id].blank?
          unless OrderCar.find_by_nr(row[:order_car_id])
            msg.contents<<"料车:#{row[:order_car_id]}不存在"
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
