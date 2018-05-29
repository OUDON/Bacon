class Submission < ApplicationRecord
  belongs_to :user
  validates :submission_id, uniqueness: true

  scope :aoj_solved_count, -> user_id { where(problem_source: 'aoj', user_id: user_id, status: 'AC')
                                        .where('length(problem_id) == 4') # problems from standard volumes
                                        .distinct
                                        .count(:problem_id) }

  def self.latest_judged_submission_id(problem_source)
    latest_judged  = Submission.order('cast(submission_id as integer) desc')
                               .where("problem_source = ? and status != 'Judging'", problem_source)
                               .limit(1)
    latest_judged[0].try('submission_id')
  end

  def self.latest_judging_submission_id(problem_source)
    latest_judging = Submission.order('cast(submission_id as integer) desc')
                               .where("problem_source = ? and status = 'Judging'", problem_source)
                               .limit(1)
    latest_judging[0].try('submission_id')
  end

  def detail_url
    case problem_source
    when "aoj"
      "http://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=#{ submission_id }#1"
    else
      "http://#{ problem_source }.contest.atcoder.jp/submissions/#{ submission_id }"
    end
  end
end
