class StandingsController < ApplicationController
  before_action :logged_in_user, only: [:show]

  def show
    @contest = Contest.find(params[:contest_id])
    @users = User.all
  end
end
