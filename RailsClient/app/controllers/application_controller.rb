class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery
  include ApplicationHelper
  before_filter :set_model
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  before_filter :get_print_server 
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
    default_printer=SysConfigCache.print_server_value
    user_printer=current_user.nil? ? nil : current_user.location.ip_detail

    @print_server="#{user_printer.blank? ? default_printer : user_printer}#{SysConfigCache.print_action_value}"
  end

  def model
    self.class.name.gsub(/Controller/, '').classify.constantize
  end

end
