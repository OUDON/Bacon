require './app/crawler/online_judge/online_judge'

module DataUpdater
  def self.update_users_info
    Rails.logger.info "Begin DataUpdater.update_users_info"
    users = User.all
    users.each do |user|
      OnlineJudge::AtCoder.update_user_info(user.atcoder_id)
      sleep(1.0)
    end
    Rails.logger.info "End DataUpdater.update_users_info"
  end

  def self.update_contests
    Rails.logger.info "Begin DataUpdater.update_contests"
    self.update_submissions
    self.update_standings
    Rails.logger.info "End DataUpdater.update_contests"
  end

  private
  def self.update_submissions
    Rails.logger.info "Begin DataUpdater.update_submissions"

    problem_sources = Set.new
    current_contests = Contest.in_progress

    current_contests.each do |contest|
      contest.problems.each do |problem|
        problem_sources.add(problem.problem_source)
      end
    end

    problem_sources.add('aoj')
    problem_sources.each do |problem_source|
      OnlineJudge.update_submissions(problem_source, diff_only: true, page_max: 50)
    end

    Rails.logger.info "End DataUpdater.update_submissions"
  end

  def self.update_standings(in_progress_only: true)
    Rails.logger.info "Begin DataUpdater.update_standings"
    current_contests = in_progress_only ? Contest.in_progress : Contest.all
    current_contests.each do |contest|
      Rails.logger.info "update_standings for #{ contest.id }"
      update_standings_for(contest)
    end
    Rails.logger.info "End DataUpdater.update_standings"
  end

  def self.update_standings_for(contest)
    standings = Standings.new(contest)
    contestants = contest.users
    submissions = Submission.joins(:user)
                            .select('submissions.*, users.*')
                            .where(users: { atcoder_id: contestants.pluck(:atcoder_id)}, date: contest.date_range)
                            .order(:submission_id)
    standings.update(submissions)
  end
end
