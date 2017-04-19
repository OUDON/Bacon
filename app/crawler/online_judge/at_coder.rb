module OnlineJudge
  require 'open-uri'
  require 'nokogiri'

  class AtCoder
    NAME_COLOR = { 
      'user-red'     => '#FF0000',
      'user-orange'  => '#FF8000',
      'user-yellow'  => '#C0C000',
      'user-blue'    => '#0000FF',
      'user-cyan'    => '#00C0C0',
      'user-green'   => '#008000',
      'user-brown'   => '#804000',
      'user-gray'    => '#808080',
      'user-unrated' => '#000000',
    }.freeze

    def self.user_exists?(atcoder_id)
      url = "https://atcoder.jp/user/#{ atcoder_id }"
      doc = Nokogiri::HTML.parse(open(url).read)
      doc.css('h3 > a.username > span').any?
    end

    def self.update_submissions(problem_source, diff_only: true, page_max: 10)
      Rails.logger.info("Crawling submissions for #{ problem_source }")

      url = 'http://' + problem_source + '.contest.atcoder.jp/submissions/all/1'
      doc = Nokogiri::HTML.parse(open(url).read)
      page_max = [page_max, doc.css('div.pagination > ul > li')[-2].children.text.to_i].min
      latest_judged_id  = ProblemSource.find_by(problem_source: problem_source).try(:latest_submission_id)

      users = User.all.group_by(&:atcoder_id)
      latest_submission_id = nil
      (1...page_max).each do |page|
        submissions =  self.get_submission(problem_source, page)
        latest_submission_id ||= submissions[0][:submission_id]
        continue = true
        for submission in submissions
          if diff_only and latest_judged_id and submission[:submission_id] <= latest_judged_id
            continue = false
            break
          end
          next unless users.has_key?(submission[:atcoder_id])

          user = users[submission[:atcoder_id]][0]
          submission.delete(:atcoder_id)
          s = Submission.find_or_initialize_by(submission_id: submission[:submission_id])
          s.update_attributes(submission)
          s.user_id = user.id
          s.save!
        end
        break unless continue
        sleep(1.0)
      end
      update_latest_submission_id(problem_source, latest_submission_id)
    end

    def self.update_user_info(atcoder_id)
      user = User.find_by(atcoder_id: atcoder_id)
      if !user
        Rails.logger.error "Called AtCoder.update_user_info for undefined user '#{ atcoder_id }'"
        return false
      end
      user_info = get_user_info(atcoder_id) 
      if user_info 
        user.update_attributes(user_info)
      end
      true
    end

    def self.get_user_info(atcoder_id)
      url = "https://atcoder.jp/user/#{ atcoder_id }"
      doc = Nokogiri::HTML.parse(open(url).read)
      user_span = doc.css('h3 > a.username > span')
      return false unless user_span.any?

      user_info = Hash.new
      user_info[:atcoder_id] = user_span.inner_text
      user_name_class = nil
      if user_span.attribute('class')
        user_name_class = user_span.attribute('class').value
        user_info[:name_color] = NAME_COLOR[user_name_class]
      else
        user_info[:name_color] = user_span.attribute('style').value.match(%r{color:(?<color>#[0-9A-F]*);})[:color]
      end
      if user_name_class == 'user-unrated'
        user_info[:atcoder_rating] = 0
      else
        user_info[:atcoder_rating] = doc.css('dd > span')[0].inner_text
      end
      user_info
    end

    def self.get_problem_info(url)
      url_regexp = /https?:\/\/(?<problem_source>.*)\.contest.atcoder.jp\/tasks\/(?<problem_id>.*)/
      url_match = url.match(url_regexp)
      return nil unless url_match

      problem_info = { 
        :problem_source => url_match[:problem_source],
        :problem_id     => url_match[:problem_id],
        :url            => url,
      }

      doc = Nokogiri::HTML.parse(open(url).read)
      title_match = doc.css('h2').inner_text.match(/.\s-\s(?<title>.*)/)
      return nil unless title_match
      problem_info[:title] = title_match[:title]
      problem_info
    end

    private
    def self.get_submission(problem_source, page)
      url = 'http://' + problem_source + '.contest.atcoder.jp/submissions/all/' + page.to_s
      doc = Nokogiri::HTML.parse(open(url).read)
      submissions = doc.css('table > tbody > tr')

      submissions_list = Array.new
      submissions.each do |submission|
        tmp = Hash.new
        tmp[:atcoder_id]     = submission.css('td > a')[1].attribute('href').value.split('/')[-1]
        tmp[:submission_id]  = submission.css('td > a')[3].attribute('href').value.split('/')[-1]
        tmp[:problem_id]     = submission.css('td > a')[0].attribute('href').value.split('/')[-1]
        tmp[:problem_source] = problem_source
        tmp[:status]         = submission.css('td > span')[0].inner_text
        tmp[:date]           = submission.css('td')[0].inner_text
        next if tmp[:status] == 'WJ' or tmp[:status].match(%r{[0-9]*\/[0-9]})
        submissions_list << tmp
      end
      submissions_list
    end

    def self.update_latest_submission_id(problem_source, latest_submission_id)
      ps = ProblemSource.find_or_initialize_by(problem_source: problem_source)
      ps.latest_submission_id = latest_submission_id
      ps.save
    end
  end
end
