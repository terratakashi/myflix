def set_current_user(user = nil)
  session[:user_id] = user || Fabricate(:user)
end

def current_user
  @user ||= User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end
