class SubmissionsController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @contest = Contest.find(params[:contest_id])
  end
end
