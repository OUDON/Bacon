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

    def self.get_submissions(contest_name)
      url = 'http://' + contest_name + '.contest.atcoder.jp/submissions/all'
      doc = Nokogiri::HTML.parse(open(url).read)
      submissions = doc.css('table > tbody > tr')

      submissions_list = Array.new
      submissions.each do |submission|
        tmp = Hash.new
        tmp[:submission_id] = submission.css('td > a')[3].attribute('href').value.split('/')[-1].to_i
        tmp[:atcoder_id]    = submission.css('td > a')[1].attribute('href').value.split('/')[-1]
        tmp[:contest] = contest_name
        tmp[:problem] = submission.css('td > a')[0].attribute('href').value.split('/')[-1]
        tmp[:status]  = submission.css('td > span')[0].inner_text
        tmp[:date]    = submission.css('td')[0].inner_text

        if tmp[:status] == 'WJ' or tmp[:status].match(%r{[0-9]*\/[0-9]})
          tmp[:status] = 'Judging'
        end
        submissions_list << tmp
      end

      submissions_list
    end

    def self.get_user_info(user_name)
      url = 'https://atcoder.jp/user/' + user_name
      doc = Nokogiri::HTML.parse(open(url).read)

      user = Hash.new
      user_span = doc.css('h3 > a.username > span')
      user[:atcoder_id] = user_span.inner_text
      if user_span.attribute('class')
        user[:color] = NAME_COLOR[user_span.attribute('class').value]
      else
        user[:color] = user_span.attribute('style').value.match(%r{color:(?<color>#[0-9A-F]*);})[:color]
      end
      user[:rating] = doc.css('dd > span')[0].inner_text 
      user
    end

    def self.get_problem_info(url)
      url_regexp = /https?:\/\/(?<contest_source>.*)\.contest.atcoder.jp\/tasks\/(?<problem_id>.*)/
      url_match = url.match(url_regexp)
      p url_match
      return nil unless url_match

      problem_info = { 
        :contest_source => url_match[:contest_source],
        :problem_id     => url_match[:problem_id],
        :url            => url,
      }

      doc = Nokogiri::HTML.parse(open(url).read)
      title_match = doc.css('h2').inner_text.match(/.\s-\s(?<title>.*)/)
      return nil unless title_match
      problem_info[:title] = title_match[:title]
      problem_info
    end
  end
end
