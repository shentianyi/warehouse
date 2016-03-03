require 'csv'
module Import
  module CsvBase
    # import by csv
    def import_csv(csv)
      msg=Message.new
      begin
        line_no=0
        CSV.foreach(csv.file_path, headers: true, col_sep: csv.col_sep, encoding: csv.encoding) do |row|
          p row
          p self.csv_headers
          p '0------------------------------------------'
          row.strip
          line_no+=1
          if self.respond_to?(:csv_headers)
            headers=self.csv_headers-row.headers
            raise(ArgumentError, "#{headers.join(' /')} 为必须包含列!") unless headers.empty?
          end
          data={}
          self.csv_cols.each do |col|
            raise(ArgumentError, "行:#{line_no} #{col.header} 值constantize不可为空") if !col.null && row[col.header].blank?
            f=nil
            if !col.is_foreign || (col.is_foreign && (f=col.foreign.constantize.send("find_by_#{col.foreign_field}", (row[col.header]))))
              data[col.field]=f.nil? ? row[col.header] : f.id
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
            if item=self.unscoped.where(query).first
              if update_marker
                item.update(data)
              else
                #raise(ArgumentError, "行:#{line_no} 已经存在")
              end
            else
              puts self.create(data)
            end
          else
            puts self.create(data)
          end
          msg.result=true
          msg.content='数据导入成功'
        end
      rescue => e
        puts e.backtrace
        msg.content =e.message
      end
      return msg
    end

    # export csv
    def export_csv(path, query)
      msg=Message.new
      #begin
      File.open(path, 'wb') do |f|
        f.puts self.csv_headers.join($CSVSP)
        items=query.nil? ? self.all : self.where(query).all
        items.each do |item|
          line=[]
          proc=self.send("#{self.to_s.underscore}_down_block".to_sym)
          proc.call(line, item)
          #补齐不足的分号
          count = line.count
          header_count = self.csv_headers.count

          if header_count > count
            (header_count-count).times.each { |i| line[count+1+i] = "" }
            line[header_count-1]=1
          end
          #
          f.puts line.join($CSVSP)
        end
      end
      msg.result=true
      #rescue => e
      #  msg.content =e.message
      #end
      #return msg
    end

  end
end
