module OnlineJudge
  URL_MATCHER = {
    AOJ =>     /http:\/\/judge\.u-aizu\.ac\.jp\/onlinejudge\/description\.jsp\?id=[0-9]+/,
    AtCoder => /https?:\/\/.+\.contest\.atcoder\.jp\/tasks\/.+/,
  }.freeze

  def self.get_problem_info(url)
    URL_MATCHER.each do |problem_source, matcher|
      if url.match(matcher)
        return problem_source.get_problem_info(url)
      end
    end
    nil
  end

  def self.update_submissions(problem_source, diff_only: true, page_max: 10)
    case problem_source
    when 'aoj'
      AOJ.update_submissions(problem_source, diff_only: diff_only, page_max: page_max)
    else
      AtCoder.update_submissions(problem_source, diff_only: diff_only, page_max: page_max)
    end
  end
end
