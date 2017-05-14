class Standings
  attr_reader :contest, :problems, :problem_idxs, :standings

  StandingsRow  = Struct.new(:user_id, :rank, :problem_statuses, :score, :penalty_time, :penalty_wa, :penalty)
  ProblemStatus = Struct.new(:accepted, :penalty_time, :penalty_wa)

  def initialize(contest)
    @contest = contest
    @problems = contest.problems
    @problem_idxs = problems.map.with_index { |p, i| [[p.problem_source, p.problem_id], i] }.to_h
  end

  def update(submissions)
    initialize_standings
    return if !contest.users.any?

    submissions.each do |submission|
      author = submission.user_id
      problem = problem_idxs[[submission.problem_source, submission.problem_id]]
      next unless problem
      next if standings[author].problem_statuses[problem].accepted
      standings_row = standings[author]
      if submission.status == 'AC'
        standings_row.problem_statuses[problem].accepted = true
        standings_row.problem_statuses[problem].penalty_time = elapsed_time(submission[:date])
        standings_row.score += 1
      elsif ['WA', 'RE', 'TLE', 'MLE'].include?(submission.status)
        standings_row.problem_statuses[problem].penalty_wa += 1
      end
    end

    compute_penalty
    compute_rank
    contest.standings = standings
    contest.save
  end

  private
  def initialize_standings
    @standings = Hash.new
    contest.users.each do |contestant|
      problem_statuses = Array.new(problems.size) { ProblemStatus.new(false, 0, 0) }
      @standings[contestant.id] = StandingsRow.new(contestant.id, -1, problem_statuses, 0, 0, 0, 0)
    end
  end

  def compute_penalty
    standings.values.each do |row|
      row.penalty_time = row.problem_statuses.map(&:penalty_time).max || 0
      row.penalty_wa = row.problem_statuses.select { |p| p.accepted }.map(&:penalty_wa).sum || 0
      row.penalty = row.penalty_time + row.penalty_wa * contest.penalty_time * 60
    end
  end

  def compute_rank
    standings_array = standings.values
    @standings = standings_array.sort_by{ |row| [-row.score, row.penalty_time + row.penalty_wa] }
    return unless standings.any?

    standings[0].rank = 1
    1.upto(standings.size - 1) do |i|
      if [standings[i].score, standings[i].penalty] == [standings[i-1].score, standings[i-1].penalty]
        standings[i].rank = standings[i-1].rank
      else
        standings[i].rank = i+1
      end
    end
  end

  def elapsed_time(at)
    at - contest.start_at
  end
end
