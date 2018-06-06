class StandingsController < ApplicationController
  before_action only: [:show] do
    contestant_user(Contest.find(params[:contest_id]))
  end

  def show
    @contest = Contest.find(params[:contest_id])
    @users = User.all
  end
end
