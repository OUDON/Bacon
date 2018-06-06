class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :admin_user?
  before_action :store_current_location, unless: :devise_controller?

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

  def contestant_user(contest)
    if !current_user
      logged_in_user
    elsif !contest.contestant?(current_user)
      flash[:danger] = '参加登録してください'
      redirect_to contest_path(contest)
    end
  end

  def admin_user?
    current_user && current_user.admin?
  end

  def store_current_location
    return if current_user
    store_location_for(:user, request.url)
  end
end
