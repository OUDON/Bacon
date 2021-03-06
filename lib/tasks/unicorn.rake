namespace :unicorn do
  desc "Start unicorn for production env."
  task(:start) do
    config_path = "#{Rails.root}/config/unicorn.rb"
    sh "unicorn_rails -c #{config_path} -E #{Rails.env} -D"
  end

  desc "Stop unicorn"
  task(:stop) { unicorn_signal :QUIT }

  desc "Restart unicorn with USR2"
  task(:restart) { unicorn_signal :USR2 }

  desc "Unicorn pstree (depends on pstree command)"
  task(:pstree) do
    sh "pstree '#{unicorn_pid}'"
  end

  def unicorn_signal signal
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      File.read("#{Rails.root}/tmp/pids/unicorn.pid").to_i
    rescue Errno::ENOENT
      raise "Unicorn doesn't seem to be running"
    end
  end
end
