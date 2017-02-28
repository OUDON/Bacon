set :output, 'log/crontab.log'
env :PATH, ENV['PATH']

job_type :runner, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && bundle exec rails runner -e :environment :task :output"
job_type :runner_with_setlock, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && setlock -n /tmp/:task bundle exec rails runner -e :environment :task :output"

every :sunday, at: '0am' do
  runner 'DataUpdater.update_users_info'
end

every 2.minutes do
  runner_with_setlock 'DataUpdater.update_submissions'
  runner_with_setlock 'DataUpdater.update_standings'
end
