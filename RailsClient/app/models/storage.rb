class Storage<ActiveRecord::Base
  include Extensions::UUID
  belongs_to :storable, polymorphic: true
  belongs_to :location
  belongs_to :part

  delegate :name,prefix: true,to: :location,allow_nil: true
  delegate :name,prefix: true,to: :storable,allow_nil: true

  def self.build_safe_stock_report csv
    msg=Message.new
    begin
      line_no=0
      CSV.foreach(csv.file_path, headers: true, col_sep: csv.col_sep, encoding: csv.encoding) do |row|
        row.strip
        line_no+=1
        # if self.respond_to?(:csv_headers)
        #   headers=self.csv_headers-row.headers
        #   raise(ArgumentError, "#{headers.join(' /')} 为必须包含列!") unless headers.empty?
        # # end
        # data={}
        # self.csv_cols.each do |col|
        #   # p col
        #   # p col.foreign.constantize
        #   # raise(ArgumentError, "行:#{line_no} #{col.header} 值constantize不可为空") if !col.null && row[col.header].blank?
        #   if !col.is_foreign || (col.is_foreign && (f=col.foreign.constantize.find_by_nr(row[col.header])))
        #     data[col.field]=row[col.header] unless row[col.header].blank?
        #     if f.present?
        #       data[col.field]=f.id
        #     end
        #
        #   end
        # end
        p row
        puts 'ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss'

        if line_no==3
          raise '------------------------------------------------------------------------------'
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
end