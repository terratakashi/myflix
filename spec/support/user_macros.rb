def set_current_user(user = nil)
  session[:user_id] = user || Fabricate(:user)
end

def current_user
  @user ||= User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def user_sign_in(existing_user = nil)
  user = existing_user || Fabricate(:user)
  visit sign_in_path
  fill_in "email", with: user.email
  fill_in "password", with: user.password
  click_button "Sign in"
end

def user_sign_out
  visit sign_out_path
end

def click_on_video_on_home_page(video)
  find("a[href='#{video_path(video)}']").click
end
