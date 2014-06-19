module Import
  module CsvBase
    # import by csv
    def import_csv(csv)
      msg=Message.new
      begin
        line_no=0
        CSV.foreach(csv.file_path, headers: true, col_sep: csv.col_sep, encoding: csv.encoding) do |row|
          row.strip
          line_no+=1
          if self.respond_to?(:csv_headers)
            headers=self.csv_headers-row.headers
            raise(ArgumentError, "#{headers} 为必须包含列!") unless headers.empty?
          end

        end
      rescue => e
        msg.content =e.message
      end
      return msg
    end
  end
end