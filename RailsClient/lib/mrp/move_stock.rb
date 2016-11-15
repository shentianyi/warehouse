require 'net/ftp'

module Mrp
  class MoveStock
    HOST='192.168.1.68'
    FTPPATH='/StockMovement/'
    LOCALPATH='public/StockMovement/'
    FROMWHOUSE='BCPW'
    TOWHOUSE='3PL'
    TOPOSITION='3PLP'

    def self.get_files
      Dir::mkdir(LOCALPATH) unless File.exist?(LOCALPATH)

      Net::FTP.open(HOST) do |ftp|
        ftp.login
        puts '---------------------------------'
        files = ftp.list(FTPPATH)
        file_names=[]
        files.each do |file|
          a = file.split(' ')
          file_names<<a[3] if a[2].to_i>0
          if a[2].to_i>0
            ftp.getbinaryfile(FTPPATH+a[3], LOCALPATH+a[3], Net::FTP::DEFAULT_BLOCKSIZE)

            File.open(LOCALPATH+a[3], 'r') do |f|
              content = f.gets.split(',')
              params={
                  partNr: content[0],
                  qty: content[1].to_i,
                  toWh: TOWHOUSE,
                  toPosition: TOPOSITION,
                  fromWh: FROMWHOUSE,
                  employee_id: 'STOCK BACKFLUSH'
              }

              WhouseService.new.move(params)
            end
          end


        end

      end

      puts 'succ'
    end

  end
end