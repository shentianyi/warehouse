module ApplicationHelper

  def import
    render 'shared/import'
  end

  def search
    @items=model.where(params[@model].clone.delete_if { |k, v| v.length==0 }).paginate(:page => params[:page], :per_page => 20)
    render :index
  end

  def download query=nil,mm=nil
    file_name=@model+".csv"
    path=File.join($DOWNLOADPATH,file_name)
    File.open(path,'wb') do |f|
      m=mm.nil? ? model : mm
      f.puts m.csv_headers.join($CSVSP)
      items=query.nil? ? m.all : m.where(query)
      items.each do |item|
        line=[]
        proc=BlockHelper.send "get_#{@model}_down_block"
        proc.call(line,item)
        f.puts line.join($CSVSP)
      end
    end
    send_file path,:type => 'application/csv', :filename =>file_name
  end

  def template
    file_name="#{@model}_csv_upload_template.csv"
    path=File.join($TEMPLATEPATH,file_name)
    send_file path,:type => 'application/csv', :filename =>file_name
  end

end
