class UsersController < ApplicationController
  # before_action :logged_in_user only: [:show]

  def index
    @users = User.all.sort_by { |u| [u.atcoder_rating, u.aoj_solved_count] }.reverse!
  end
end
