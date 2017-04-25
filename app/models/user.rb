class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation :blank_to_nil

  validates :user_name,  uniqueness: true, presence: true
  validates :atcoder_id, uniqueness: true, presence: true
  validates :aoj_id,     uniqueness: true, allow_nil: true
  validate :online_judge_id_must_exists

  has_many :contestants, dependent: :destroy
  has_many :contests,    through: :contestants
  has_many :submissions, dependent: :destroy

  def aoj_solved_count
    aoj_id ? Submission.aoj_solved_count(self.id) : '-'
  end

  private
  def blank_to_nil
    self.aoj_id = nil if aoj_id == ""
  end

  def online_judge_id_must_exists
    column_name = {
      OnlineJudge::AtCoder => :atcoder_id,
      OnlineJudge::AOJ     => :aoj_id,
    }

    column_name.each do |problem_source, id_name|
      id = self.send(id_name)
      if id && !problem_source.user_exists?(id)
        errors.add(id_name, ' が存在しません')
      end
    end
  end
end
