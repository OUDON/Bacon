class ContestantsController < ApplicationController
  def create
    @contest = Contest.find(params[:contest_id])
    @contest.registration(current_user)
    DataUpdater.update_standings_for(@contest)
    redirect_to contest_path(@contest.id)
  end
end
