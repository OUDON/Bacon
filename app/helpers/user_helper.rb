module UserHelper
  def aoj_solved_count(user)
    user.aoj_id ? user.aoj_solved_count : "-"
  end
end
