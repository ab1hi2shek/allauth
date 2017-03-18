class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def current_user
  	@current_user ||= User.find_by(id: session[:user_id])
  end

helper_method :current_user

rescue_from CanCan::AccessDenied do | exception |
    redirect_to '/', alert: "Please log in! or You are not authorised!"
  end

  def authenticate
     if !current_user
       flash[:error] = "Please Sign In"
       redirect_to root_path
     end
 end
end
