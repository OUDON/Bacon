class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :contestants, dependent: :destroy
  has_many :contests,    through: :contestants
  has_many :submissions, dependent: :destroy
end
