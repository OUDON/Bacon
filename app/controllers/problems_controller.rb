class ProblemsController < ApplicationController
  def create
    problem_info = OnlineJudge::AtCoder.get_problem_info(params[:problem][:url])
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
  end
end