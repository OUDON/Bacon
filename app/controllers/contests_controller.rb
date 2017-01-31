class ContestsController < ApplicationController
  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new(contest_params)
    if @contest.save
    else
      render 'new'
    end
  end

  def show
    @contest = Contest.find(params[:id])
  end

  private
  def contest_params
    params.require(:contest).permit(:title, :penalty_time, :start_at, :end_at)
  end
end
