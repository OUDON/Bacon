class Standings
  attr_reader :contest, :problems, :problem_idxs, :standings

  StandingsRow  = Struct.new(:user_info, :rank, :problem_statuses, :score, :penalty_time, :penalty_wa)
  ProblemStatus = Struct.new(:accepted, :penalty_time, :penalty_wa)

  def initialize(contest)
    @contest = contest
    @problems = contest.problems
    @problem_idxs = problems.map.with_index { |p, i| [[p.problem_source, p.problem_id], i] }.to_h
  end

  def update(submissions)
    return unless contest.users.any?
    initialize_standings
    submissions.each do |submission|
      author = submission.user_id
      problem = problem_idxs[[submission.problem_source, submission.problem_id]]
      next unless problem
      next if standings[author].problem_statuses[problem].accepted
      standings_row = standings[author]
      if submission.status == 'AC'
        standings_row.problem_statuses[problem].accepted = true
        standings_row.penalty_wa += standings_row.problem_statuses[problem].penalty_wa
        standings_row.score += 1
      elsif ['WA', 'RE', 'TLE', 'MLE'].include?(submission.status)
        standings_row.problem_statuses[problem].penalty_wa += 1
      end
    end
    compute_rank
    contest.standings = standings
    contest.save
  end

  private
  def initialize_standings
    @standings = Hash.new
    contest.users.each do |contestant|
      user_info = {
        id:          contestant.id,
        screen_name: contestant.screen_name,
        name_color:  contestant.name_color,
      }
      problem_statuses = Array.new(problems.size) { ProblemStatus.new(false, 0, 0) }
      @standings[contestant.id] = StandingsRow.new(user_info, -1, problem_statuses, 0, 0, 0)
    end
  end

  def compute_rank
    standings_array = standings.values
    @standings = standings_array.sort_by{ |row| [-row.score, row.penalty_time + row.penalty_wa] }
    return unless standings.any?

    standings[0].rank = 1
    1.upto(standings.size - 1) do |i|
      if [standings[i].score, standings[i].penalty_wa] == [standings[i-1].score, standings[i-1].penalty_wa]
        standings[i].rank = standings[i-1].rank
      else
        standings[i].rank = i+1
      end
    end
  end
end
