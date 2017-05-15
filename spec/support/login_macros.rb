module LoginMacros
  def log_in(user)
    visit root_path
    click_link "ログイン"
    fill_in "ユーザ名", with: user.user_name
    fill_in "パスワード", with: user.password
    click_button "Log in"
  end
end
