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
          data={}
          self.csv_cols.each do |col|
            raise(ArgumentError, "行:#{line_no} #{col.header} 值不可为空") if !col.null && row[col.header].empty?
            if !col.is_foreign || (col.is_foreign && col.foreign.constantize.find_by_id(row[col.header]))
              data[col.field]=row[col.header]
            end
          end
          query=nil
          # check uniq
          if self.respond_to?(:uniq_key)
            query={}
            self.uniq_key.each do |key|
              query[key]=data[key]
            end
          end
          # clean data
          update_marker=(data.delete($UPMARKER).to_i==1)
          if query
            if item=self.where(query).first
              item.update(data) if update_marker
            else
              self.create(data)
            end
          else
            self.create(data)
          end
          msg.result=true
          msg.content='数据导入成功'
        end
      rescue => e
        msg.content =e.message
      end
      return msg
    end
  end
end