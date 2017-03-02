class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :user_name, uniqueness: true, presence: true

  has_many :contestants, dependent: :destroy
  has_many :contests,    through: :contestants
  has_many :submissions, dependent: :destroy

  # def self.find_first_by_auth_conditions(warden_conditions)
  #   debugger
  #   conditions = warden_conditions.dup
  #   if login = conditions.delete(:login)
  #     where(conditions).where(["user_name = :value", { value: user_name }]).first
  #   else
  #     where(conditions).first
  #   end
  # end
end
