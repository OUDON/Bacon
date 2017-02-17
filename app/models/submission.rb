class Submission < ApplicationRecord
  belongs_to :user
  validates :submission_id, uniqueness: true

  def self.latest_judged_submission_id(problem_source)
    latest_judged  = Submission.order(submission_id: :desc)
                               .where("problem_source = ? and status != 'Judging'", problem_source)
                               .limit(1)
    latest_judged[0].try('submission_id')
  end

  def self.latest_judging_submission_id(problem_source)
    latest_judging = Submission.order(submission_id: :desc)
                               .where("problem_source = ? and status = 'Judging'", problem_source)
                               .limit(1)
    latest_judging[0].try('submission_id')
  end
end
