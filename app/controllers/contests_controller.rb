class ContestsController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update]
  before_action :logged_in_user, only: [:show, :index]
  
  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new(contest_params)
    if @contest.save
      flash[:success] = 'コンテストを作成しました'
      redirect_to edit_contest_path(@contest.id)
    else
      render 'new'
    end
  end

  def index
    @contests_current = Contest.in_progress
    @contests_future  = Contest.future
    @contests_past    = Contest.past
  end

  def show
    @contest = Contest.find(params[:id])
  end

  def edit
    @contest = Contest.find(params[:id])
    @new_problem = Problem.new
  end

  def update
    @contest = Contest.find(params[:id])
    if @contest.update_attributes(contest_params)
      flash[:success] = "コンテスト情報を編集しました"
      redirect_to @contest
    else
      render 'edit'
    end
  end

  # def add_problem
  #   problem_info = OnlineJudge::AtCoder.get_problem_info(params[:problem][:url])
  #   if problem_info
  #     contest = Contest.find(params[:id])
  #     flash[:danger] = '問題を追加できませんでした' unless contest.problems.create(problem_info)
  #   else
  #     flash[:danger] = '問題 URL が間違っています'
  #   end
  #   redirect_to edit_contest_path
  # end

  private
  def contest_params
    params.require(:contest).permit(:title, :penalty_time, :start_at, :end_at, :user_id)
  end
end
