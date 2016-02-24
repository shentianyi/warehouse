class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery
  include ApplicationHelper
  before_filter :set_model
  before_action :get_print_server
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
#  before_filter :inventory_lock!
  # before_filter :set_current_user
  #============
  # fix cancan "ActiveModel::ForbiddenAttributesError" with Rails 4
  # see https://github.com/ryanb/cancan/issues/835
  #============
  before_filter do
    unless ['syncs'].include?(controller_name)
      resource = controller_name.singularize.to_sym
      method = "#{resource}_params"
      unless ['search'].include?(action_name)
        params[resource] &&= send(method) if respond_to?(method, true)
      end
    end
  end

  layout :layout_by_resource

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protected

  def layout_by_resource
    if devise_controller?
      "no_authorization"
    else
      "application"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :user_no
  end

  def inventory_lock!
    if current_user
      if SysConfigCache.inventory_enable_value=='true' && (current_user.sender? || current_user.receiver? || current_user.stocker? || current_user.shifter? || current_user.buyer?)
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        redirect_to new_user_session_path, alert: '盘点中...登陆锁定!'
      end
    end
  end

  private
  def authenticate_user_from_token!
    # Need to pass email and token every request
    user_email = params[:user_email].presence
    user = user_email && User.find_by_email(user_email)

    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end


  def set_model
    @model=self.class.name.gsub(/Controller/, '').tableize.singularize
  end

  def get_print_server
    @print_server="#{SysConfigCache.print_server_value}/printer/print/"
  end

  def model
    self.class.name.gsub(/Controller/, '').classify.constantize
  end

end
