#encoding: utf-8
class CSV
  class Row
    def strip
      self.each do |value|
        value[1].strip! if value[1]
      end
    end
  end
end

module FileHelper
  def updata
    msg=Message.new
    begin
      files=params[:files]
      if files.count==1
        file=files[0]
        csv=FileData.new(:data => file, :oriName => file.original_filename, :path => $UPDATAPATH, :pathName => Time.now.strftime('%Y%m%d%H%M%S')+file.original_filename)
        csv.saveFile
        hfile=File.join($UPDATAPATH, csv.pathName)
        row_line=0
        csv_encode=FileHelper.csv_write_encode request.user_agent
        CSV.foreach(hfile, :headers => true, :col_sep => $CSVSP, :encoding => csv_encode) do |row|
          row.strip
          row_line+=1
          m=model
          uniquery=nil
          if m.respond_to?(:csv_headers)
            rheader=m.csv_headers-row.headers
            raise(ArgumentError, "#{rheader}为必需包含列！") unless rheader.empty?
          end
          data={}
          query=nil
          if block_given?
            if m.respond_to?(:uniq)
              query={}
            end
            yield(data, query, row, row_line)
          end
          data.delete($UPMARKER)
          if query
            if item=m.find_by(query)
              item.update_attributes(data) if row[$UPMARKER].to_i==1
            else
              m.create(data)
            end
          else
            m.create(data)
          end
        end
        msg.result=true
        msg.content='新建/更新成功!'
      else
        msg.content='未选择文件或只能上传一个文件'
      end
    rescue Exception => e
      msg.content=e.message
    end
    render :json => msg
  end

  def download query=nil, mm=nil
    file_name=@model+".csv"
    path=File.join($DOWNLOADPATH, file_name)
    File.open(path, 'wb') do |f|
      m=mm.nil? ? model : mm
      f.puts m.csv_headers.join($CSVSP)
      items=query.nil? ? m.all : m.where(query)
      items.each do |item|
        line=[]
        proc=BlockHelper.send "get_#{@model}_down_block"
        proc.call(line, item)
        f.puts line.join($CSVSP)
      end
    end
    send_file path, :type => 'application/csv', :filename => file_name
  end

  def template
    file_name="#{@model}_csv_upload_template.csv"
    path=File.join($TEMPLATEPATH, file_name)
    send_file path, :type => 'application/csv', :filename => file_name
  end

  # ws : get os name
  def self.get_os_name user_agent
    user_agent=user_agent.downcase
    [/windows/, /linux/].each do |o|
      if os=o.match(user_agent)
        return os[0]
      end
    end
  end

  # ws : csv encode
  def self.csv_write_encode user_agent

    user_agent=user_agent.downcase
    os=nil
    [/windows/, /linux/].each do |o|
      if s=o.match(user_agent)
        os=s[0]
        break
      end
    end

    case os
      when 'windows'
        return 'GB18030'
      when 'linux'
        return 'UTF-8'
      else
        return nil
    end
  end

end
