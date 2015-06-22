class FilesController<ApplicationController
  skip_before_filter :configure_permitted_parameters

  def download
    path=File.join('uploadfiles', params[:folder], params[:file])
    send_file path, :filename => params[:file]
  end

  def index
    puts params
    # send_file File.join($TEMPLATEPATH, params[:id]+'.'+params[:format])

  end

  def show
    send_file Base64.urlsafe_decode64(params[:id])
  end
end