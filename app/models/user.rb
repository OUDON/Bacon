class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :user_name,  uniqueness: true, presence: true
  validates :atcoder_id, uniqueness: true, presence: true
  validates :aoj_id,     uniqueness: true, presence: true
  validate :online_judge_id_must_exists

  has_many :contestants, dependent: :destroy
  has_many :contests,    through: :contestants
  has_many :submissions, dependent: :destroy

  def online_judge_id_must_exists
    column_name = {
      OnlineJudge::AtCoder => :atcoder_id,
      OnlineJudge::AOJ     => :aoj_id,
    }

    column_name.each do |problem_source, id|
      unless problem_source.user_exists?(self.send(id))
        errors.add(id, ' が存在しません')
      end
    end
  end
end
