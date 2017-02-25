class ContestantsController < ApplicationController
  def create
    @contest = Contest.find(params[:contest_id])
    if @contest.in_progress? or @contest.future?
      @contest.registration(current_user)
      DataUpdater.update_standings_for(@contest)
      redirect_to contest_path(@contest.id)
    else
      flash[:danger] = '終了したコンテストには参加できません'
      redirect_to :back
    end
  end
end
