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

    def self.update_submissions(contest_name, diff_only: true, page_max: 10)
      Rails.logger.info("Crawling submissions for #{ contest_name }")

      url = 'http://' + contest_name + '.contest.atcoder.jp/submissions/all/1'
      doc = Nokogiri::HTML.parse(open(url).read)
      page_max = [page_max, doc.css('div.pagination > ul > li')[-2].children.text.to_i].min

      latest_judged_id  = Submission.latest_judged_submission_id(contest_name)
      latest_judging_id = Submission.latest_judging_submission_id(contest_name)

      users = User.all.group_by(&:atcoder_id)
      (1...page_max).each do |page|
        submissions =  self.get_submission(contest_name, page)
        for submission in submissions
          return if diff_only and latest_judged_id and submission[:submission_id] <= latest_judged_id
          next unless users.has_key?(submission[:atcoder_id])
          user = users[submission[:atcoder_id]][0]
          submission.delete(:atcoder_id)

          if latest_judging_id and submission[:submission_id] <= latest_judging_id
            status_changed = user.submissions.find_by(submission_id: submission[:submission_id])
            status_changed.update_attributes(submission)
          else
            user.submissions.create(submission)
          end
        end
        sleep(1.0)
      end
    end

    def self.update_user_info(atcoder_id)
      url = 'https://atcoder.jp/user/' + atcoder_id
      doc = Nokogiri::HTML.parse(open(url).read)

      user = User.find_by(atcoder_id: atcoder_id)
      unless user
        Rails.logger.error "Called AtCoder.update_user_info for undefined user '#{ atcoder_id }'"
        return
      end

      user_info = Hash.new
      user_span = doc.css('h3 > a.username > span')
      user_info[:atcoder_id] = user_span.inner_text
      if user_span.attribute('class')
        user_info[:name_color] = NAME_COLOR[user_span.attribute('class').value]
      else
        user_info[:name_color] = user_span.attribute('style').value.match(%r{color:(?<color>#[0-9A-F]*);})[:color]
      end
      user_info[:atcoder_rating] = doc.css('dd > span')[0].inner_text 

      user.update_attributes(user_info)
    end

    def self.get_problem_info(url)
      url_regexp = /https?:\/\/(?<problem_source>.*)\.contest.atcoder.jp\/tasks\/(?<problem_id>.*)/
      url_match = url.match(url_regexp)
      p url_match
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
    def self.get_submission(contest_name, page)
      url = 'http://' + contest_name + '.contest.atcoder.jp/submissions/all/' + page.to_s
      doc = Nokogiri::HTML.parse(open(url).read)
      submissions = doc.css('table > tbody > tr')

      submissions_list = Array.new
      submissions.each do |submission|
        tmp = Hash.new
        tmp[:atcoder_id]     = submission.css('td > a')[1].attribute('href').value.split('/')[-1]
        tmp[:submission_id]  = submission.css('td > a')[3].attribute('href').value.split('/')[-1]
        tmp[:problem_id]     = submission.css('td > a')[0].attribute('href').value.split('/')[-1]
        tmp[:problem_source] = contest_name
        tmp[:status]         = submission.css('td > span')[0].inner_text
        tmp[:date]           = submission.css('td')[0].inner_text
        if tmp[:status] == 'WJ' or tmp[:status].match(%r{[0-9]*\/[0-9]})
          tmp[:status] = 'Judging'
        end
        submissions_list << tmp
      end
      submissions_list
    end
  end
end
