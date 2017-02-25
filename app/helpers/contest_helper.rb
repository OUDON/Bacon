module ContestHelper
  def penalty_time_str(time)
    sprintf("%02d:%02d", (time / 60).to_i, (time % 60).to_i)
  end
end
