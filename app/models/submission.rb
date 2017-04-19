class Submission < ApplicationRecord
  belongs_to :user
  validates :submission_id, uniqueness: true

  scope :aoj_solved_count, -> user { where(problem_source: 'aoj', user_id: user.id, status: 'AC')
                                     .where('cast(problem_id as integer) < 10000')
                                     .distinct
                                     .count(:problem_id) }

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
