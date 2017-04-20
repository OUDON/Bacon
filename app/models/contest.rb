class Contest < ApplicationRecord
  require 'standings'

  has_many :contestants, dependent: :destroy
  has_many :users,       through: :contestants
  has_many :problems,    dependent: :destroy
  serialize :standings, Array

  validates :title,    presence: true, length: { maximum: 50 }
  validates :start_at, presence: true
  validates :end_at,   presence: true
  validate :correct_date_range

  scope :in_progress, ->(at=Time.now) { where('start_at <= ? and ? < end_at', at, at) }
  scope :future,      ->(at=Time.now) { where('start_at > ?', at) }
  scope :past,        ->(at=Time.now) { where('end_at <= ?', at) }

  def registration(user)
    contestants.create(user_id: user.id) unless contestants.exists?(user_id: user.id)
  end

  def date_range
    start_at..end_at
  end

  def in_progress?(at=Time.now)
    start_at <= at and at < end_at
  end

  def future?(at=Time.now)
    start_at > at
  end

  def past?(at=Time.now)
    end_at <= at
  end

  def contestant?(user)
    users.include?(user)
  end

  private
  def correct_date_range
    unless start_at < end_at
      errors.add(:start_at, " は終了時刻より前に設定して下さい")
    end
  end
end
