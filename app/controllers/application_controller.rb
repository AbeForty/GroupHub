class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  def current_organization
    Organization.find_by(users_id:session[:user_id]) if session[:user_id]
  end
  helper_method :current_organization
  def require_login
    redirect_to '/' if session[:user_id] == nil
  end

  def require_correct_user
    user = User.find(params[:id])
    redirect_to '/' if current_user != user
  end

end
