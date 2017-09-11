require './app/crawler/online_judge/online_judge'

class ProblemsController < ApplicationController
  before_action :admin_user, only: [:create, :destroy]
  before_action :logged_in_user, only: [:index]

  def index
    @contest = Contest.find(params[:contest_id])
  end

  def create
    problem_info = OnlineJudge.get_problem_info(params[:problem][:url])
    contest = Contest.find(params[:contest_id])
    if problem_info
      if contest.problems.create(problem_info)
        DataUpdater::update_standings_for(contest)
        flash[:success] = '問題を追加しました'
      else
        flash[:danger] = '問題を追加できませんでした'
      end
    else
      flash[:danger] = '問題 URL が間違っています'
    end
    redirect_to edit_contest_path(contest)
  end

  def destroy
    contest = Contest.find(params[:contest_id])
    contest.problems.find(params[:id]).destroy
    flash[:success] = '問題を削除しました'
    DataUpdater::update_standings_for(contest)
    redirect_to edit_contest_path(contest)
  end
end
