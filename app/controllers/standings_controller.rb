class StandingsController < ApplicationController
  before_action only: [:show] do
    contest = Contest.find(params[:contest_id])
    contestant_user(contest) if !contest.past?
  end

  def show
    @contest = Contest.find(params[:contest_id])
    @users = User.all
  end
end
