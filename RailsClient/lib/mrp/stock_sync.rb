require 'net/ftp'

module Mrp
  class StockSync

    HOST='192.168.1.68'
    LOCALFILE='/home/lzd/p/warehouse/RailsClient/sync_file/storage.xlsx'
    FILENAME='sync/STOCK.xlsx'

    def self.generate_file
      p = Axlsx::Package.new

      wb = p.workbook
      wb.add_worksheet(:name => "Basic Sheet") do |sheet|
        sheet.add_row ["零件号", "唯一码", "数量", "时间"]

        Movement.where(created_at: ((Time.now-2.hours)..Time.now), type_id: MoveType.find_by_typeId('ENTRY').id).each do |storage|

        # NStorage.where(created_at: ((Time.now-2.hours)..Time.now)).each do |storage|
        # NStorage.where('packageId IS NOT NULL').limit(3).each do |storage|
          # NStorage.where(packageId: 'P160929133105366').each do |storage|

          sheet.add_row [
                            storage.partNr,
                            storage.packageId,
                            storage.qty,
                            storage.fifo.present? ? storage.fifo.localtime.strftime("%Y-%m-%d %H:%M") : Time.now.localtime.strftime("%Y-%m-%d %H:%M")
                        ]
        end
      end

      p.serialize('sync_file/storage.xlsx')
    end

    def self.send_file
      self.generate_file

      Net::FTP.open(HOST) do |ftp|
        ftp.login
        ftp.putbinaryfile(LOCALFILE, FILENAME, Net::FTP::DEFAULT_BLOCKSIZE)
      end

      puts 'succ'
    end

  end
end