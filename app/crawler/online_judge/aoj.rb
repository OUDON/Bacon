module OnlineJudge
  require 'open-uri'
  require 'nokogiri'

  class AOJ
    def self.get_submission(aoj_id, page)
      url = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/status_log?user_id=#{ aoj_id }&start=#{ page * 100 }&limit=100"
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
        # tmp[:date]           = 
        submission_list << tmp if tmp[:status]
      end
      submission_list
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
