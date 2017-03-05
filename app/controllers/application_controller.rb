class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
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
end
