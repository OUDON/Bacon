class UsersController < ApplicationController
  before_action :logged_in_user

  def index
    @users = User.order(atcoder_rating: :desc)
  end
end
