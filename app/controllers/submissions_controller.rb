class SubmissionsController < ApplicationController
  before_action only: [:index] do
    contest = Contest.find(params[:contest_id])
    contestant_user(contest) if !contest.past?
  end

  def index
    @contest = Contest.find(params[:contest_id])
  end
end
