class Storage<ActiveRecord::Base
  include Extensions::UUID
  belongs_to :storable, polymorphic: true
  belongs_to :location
  belongs_to :part

  delegate :name, prefix: true, to: :location, allow_nil: true
  delegate :name, prefix: true, to: :storable, allow_nil: true

  def self.build_safe_stock_report file
    jsfile = JSON.parse(file)
    f = FileData.new(jsfile)

    msg=Message.new
    # begin
      data={}
      part_list=[]
      line_no=0
      CSV.foreach(f.full_path, headers: false, col_sep: ',') do |row|
        # row.strip
        line_no+=1
        next if line_no<3

        # p row[11].gsub(/ /, '')
        # puts row[26]
        # puts row[29]

        part_nr=row[11].gsub(/ /, '')
        if data[part_nr].blank?
          part_list<<part_nr
          data[part_nr]={row[29].to_s => row[26]}
        else
          data[part_nr][row[29].to_s]=row[26]
        end


        if line_no==800
          break
        end
      end

      msg.result=true
      msg.content='数据导入成功'
      msg.object={data: data, part_list: part_list}
      # p data
    # rescue => e
    #   puts e.backtrace
    #   msg.content =e.message
    # end
    return msg
  end
end