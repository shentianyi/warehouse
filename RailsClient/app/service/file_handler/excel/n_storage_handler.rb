module FileHandler
  module Excel
    class NStorageHandler<Base

      HEADERS=[
          :toWh,:partNr,:fifo,:qty,:toPosition,:packageId,:uniqeId, :employee_id, :remarks
      ]

      def self.import(file)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first
        begin
          NStorage.transaction do
            2.upto(book.last_row) do |line|
              row = {}
              HEADERS.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip
                if k== :partNr || k== :packageId
                  row[k] = row[k].sub(/\.0/, '')
                end
              end

              WhouseService.new.enter_stock(row)

            end
          end
          msg.result = true
          msg.content = "导入库存数据成功"
        rescue => e
          puts e.backtrace
          msg.result = false
          msg.content = e.message
        end
        msg
      end

      def self.move(file)
        heads = [:fromWh, :fromPosition, :uniqeId, :packageId, :partNr, :qty, :fifo, :toWh, :toPosition, :employee_id, :remarks]
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first
        begin
          NStorage.transaction do
            2.upto(book.last_row) do |line|
              row = {}
              heads.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip
                if k== :partNr || k== :packageId
                  row[k] = row[k].sub(/\.0/, '')
                end
              end

              WhouseService.new.move(row)

            end
          end
          msg.result = true
          msg.content = "导入移库数据成功"
        rescue => e
          puts e.backtrace
          msg.result = false
          msg.content = e.message
        end
        msg
      end

    end
  end
end