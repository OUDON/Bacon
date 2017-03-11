app_path = File.dirname(File.dirname(Dir.pwd))

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2)
timeout 30
preload_app true

working_directory "#{ app_path }/current"
listen "#{ app_path }/current/tmp/sockets/unicorn.sock"
pid "#{ app_path }/current/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

stderr_path "#{ app_path }/shared/log/unicorn.stderr.log"
stdout_path "#{ app_path }/shared/log/unicorn.stdout.log"
