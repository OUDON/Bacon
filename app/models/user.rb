class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :user_name, uniqueness: true, presence: true
  validates :atcoder_id, uniqueness: true, presence: true
  validate :atcoder_id_must_exists

  has_many :contestants, dependent: :destroy
  has_many :contests,    through: :contestants
  has_many :submissions, dependent: :destroy

  def atcoder_id_must_exists
    unless OnlineJudge::AtCoder.get_user_info(atcoder_id)
      errors.add(:atcoder_id, ' が存在しません')
    end
  end
end
