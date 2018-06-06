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

  scope :in_progress, ->(at=Time.now) { where('start_at <= ? and ? < end_at', at, at).order(:start_at, :end_at) }
  scope :future,      ->(at=Time.now) { where('start_at > ?', at).order(:start_at, :end_at) .order(:start_at, :end_at) }
  scope :past,        ->(at=Time.now) { where('end_at <= ?', at).order(end_at: :desc, start_at: :desc) }

  def registration(user)
    contestants.create(user_id: user.id) unless contestants.exists?(user_id: user.id)
  end

  def date_range
    start_at..end_at
  end

  def duration
    ((end_at.to_time - start_at.to_time)/60).to_i
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

  def problem_sources
    problems.pluck(:problem_source).uniq
  end

  def problem_ids
    problems.pluck(:problem_id).uniq
  end

  def submissions
    Submission.joins(:user)
              .joins('inner join problems on submissions.problem_source = problems.problem_source and submissions.problem_id = problems.problem_id')
              .select('submissions.*, users.*, problems.title, problems.url')
              .where(users: { id: contestants.pluck(:user_id) }, date: date_range)
              .where(submissions: { problem_source: problem_sources, problem_id: problem_ids})
              .order(date: :desc)
              .uniq(:submission_id)
  end

  private
  def correct_date_range
    unless start_at < end_at
      errors.add(:start_at, " は終了時刻より前に設定して下さい")
    end
  end
end
