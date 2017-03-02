class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :admin_user?

  def admin_user
    if !current_user or !current_user.admin?
      flash[:danger] = '編集する権限がありません'
      redirect_to root_path
    end
  end

  def logged_in_user
    if !current_user
      flash[:danger] = 'ログインしてください'
      redirect_to new_user_session_path
    end
  end

  def admin_user?
    current_user && current_user.admin?
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :atcoder_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :atcoder_id])
  end
end
