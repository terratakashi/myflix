def user_sign_in(user = nil)
  session[:user_id] = user || Fabricate(:user)
end

def current_user
  @user ||= User.find(session[:user_id])
end

def user_sign_out
  session[:user_id] = nil
end
