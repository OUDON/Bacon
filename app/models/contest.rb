class Contest < ApplicationRecord
  require 'standings'

  has_many :contestants, dependent: :destroy
  has_many :users,       through: :contestants
  has_many :problems, dependent: :destroy
  serialize :standings, Array
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

  def past?(at=Time.now)
    end_at <= at
  end

  def contestant?(user)
    users.include?(user)
  end
end
