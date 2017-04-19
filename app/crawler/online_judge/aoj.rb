module OnlineJudge
  require 'open-uri'
  require 'nokogiri'

  class AOJ
    API_URL_BASE = 'http://judge.u-aizu.ac.jp/onlinejudge/webservice/'

    def self.user_exists?(aoj_id)
      url = API_URL_BASE + "user?id=#{ aoj_id }"
      xml = Nokogiri::XML.parse(open(url).read)
      xml.css('user > id').any?
    end

    def self.update_submissions(problem_source, diff_only: true, page_max: 10)
      users = User.all
      users.each do |user|
        next unless user.aoj_id
        latest_judged_id = Submission.latest_judged_submission_id("aoj")

        (0...page_max).each do |page|
          submissions = get_submissions(user.aoj_id, page)
          break unless submissions.any?
          continue = true

          submissions.each do |submission|
            if latest_judged_id && submission[:submission_id] <= latest_judged_id
              continue = false 
              break
            end

            submission.delete(:aoj_id)
            s = user.submissions.build(submission)
            s.save!
          end

          sleep(1.0)
          break if !diff_only and  continue
        end
      end
    end

    def self.get_submissions(aoj_id, page=0)
      url = API_URL_BASE + "status_log?user_id=#{ aoj_id }&start=#{ page * 100 }&limit=100"
      xml = Nokogiri::XML.parse(open(url).read)

      submissions = xml.css('status_list > status')
      submission_list = Array.new
      submissions.each do |submission|
        tmp = Hash.new
        tmp[:aoj_id]         = submission.css('user_id').text.strip
        tmp[:submission_id]  = submission.css('run_id').text.strip
        tmp[:problem_id]     = submission.css('problem_id').text.strip
        tmp[:problem_source] = 'aoj'
        tmp[:status]         = convert_status(submission.css('status').text.strip)

        delayed_mm_sec = submission.css('submission_date').text.strip.to_i
        tmp[:date] = Time.at(delayed_mm_sec / 1000) 

        submission_list << tmp if tmp[:status]
      end
      submission_list
    end

    def self.get_problem_info(url)
      url_regexp = /http:\/\/judge\.u-aizu\.ac\.jp\/onlinejudge\/description\.jsp\?id=(?<problem_id>[0-9]+)/
      url_match = url.match(url_regexp)
      return nil unless url_match

      problem_info = {
        problem_source: 'aoj',
        problem_id:     url_match[:problem_id],
        url:            url,
      }
      
      doc = Nokogiri::HTML.parse(open(url).read)
      problem_info[:title] = doc.css('h1.title').inner_text
      return nil if problem_info[:title].empty?
      
      problem_info
    end

    def self.convert_status(status)
      case status
      when 'Accepted'
        'AC'
      when 'Wrong Answer'
        'WA'
      when 'Runtime Error'
        'RE'
      when 'Memory Limit Exceeded'
        'MLE'
      when 'Time Limit Exceeded'
        'TLE'
      end
    end

  end
end
