class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname, :username, :password_confirmation])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :remember_me])
    end
    
   def require_user
     unless logged_in?
      flash[:info] = "Debes ingresar para poder hacerlo"
      redirect_to root_path
    end
  end
  def after_sign_in_path_for(resource)
    root_path
  end
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
