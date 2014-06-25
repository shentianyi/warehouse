class LabelsController < ApplicationController
  #skip_before_filter :set_model
  skip_before_filter :configure_permitted_parameters, if: :devise_controller?
  skip_before_filter :authenticate_user_from_token!
  skip_before_filter :authenticate_user!
  before_action :set_attachment_type
  before_action :get_attach, only: [:get_config, :get_config_hash, :get_config_version]

  def index
    @labels=Attachment.paginate(:page => params[:page]).where(attachable_type: @type).order(:created_at)
  end

  def new
    @label=Attachment.new
    @types=PrintLabelEnum.enums
  end

  def create
    fd= FileData.new(JSON.parse(params[:file]))
    puts fd.oriName
    @attach=Attachment.new(type: params[:attachment][:type], attachable_type: @type, name: fd.oriName, path: fd.path, path_name: fd.pathName, version: Time.now.strftime('%Y%m%d%H%M%S%L'))
    @attach.md5=Digest::MD5.file(fd.full_path).hexdigest
    @attach.save

    respond_to do |format|
      if @attach.save
        format.html { redirect_to labels_path, notice: '配置文件创建成功.' }
      else
        format.html { render :new }
      end
    end
  end


  def destroy
    @attach=Attachment.unscoped.find(params[:id])
    @attach.destroy
    respond_to do |format|
      format.html { redirect_to labels_path, notice: '配置文件删除成功.' }
      format.json { head :no_content }
    end
  end

  def upload_file
    msg=Message.new
    if params[:files].size==1
      path=File.join($UPDATAPATH, 'labels')
      file=params[:files][0]
      fd=FileData.new(data: file, oriName: file.original_filename, path: path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
      fd.saveFile
      msg.result =true
      msg.content =fd
    else
      msg.content='未选择文件或只能上传一个文件'
    end
    render json: msg
  end

  def get_config
    send_file File.join(@attach.path, @attach.path_name)
  end


  def get_config_hash
    render json: @attach.md5
  end

  def get_config_version
    render json: @attach.version
  end

  private
  def set_attachment_type
    @type='Label'
  end

  def get_attach
    @attach=Attachment.where(type: params[:type]).order(version: :desc).first
  end

  def get_file_folder
    'labels'
  end
end