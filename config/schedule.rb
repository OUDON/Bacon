set :output, 'log/crontab.log'
set :environment, :development

job_type :runner, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rails runner :task :output"

every :sunday, at: '0am' do
  runner 'DataUpdater.update_users_info'
end

every 2.minutes do
  runner 'DataUpdater.update_submissions'
  runner 'DataUpdater.update_standings'
end
