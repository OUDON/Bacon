module DataUpdater
  def self.update_users_info
    Rails.logger.info "Begin DataUpdater.update_users_info"
    users = User.all
    users.each do |user|
      OnlineJudge::AtCoder.update_user_info(user.atcoder_id)
      sleep(1.0)
    end
    Rails.logger.info "Succeded DataUpdater.update_users_info"
  end

  def self.update_submissions
    current_contests = Contest.in_progress
    problem_sources = Set.new
    current_contests.each do |contest|
      contest.problems.each do |problem|
        problem_sources.add(problem.problem_source)
      end
    end
    problem_sources.each do |problem_source|
      OnlineJudge::AtCoder.update_submissions(problem_source)
    end
  end

  def self.update_standings
    current_contests = Contest.in_progress
    current_contests.each do |contest|
      update_standings_for(contest)
    end
  end

  private
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

