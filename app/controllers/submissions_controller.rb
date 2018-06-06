class SubmissionsController < ApplicationController
  before_action only: [:index] do
    contestant_user(Contest.find(params[:contest_id]))
  end

  def index
    @contest = Contest.find(params[:contest_id])
  end
end
