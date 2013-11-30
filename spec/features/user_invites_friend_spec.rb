require "spec_helper"

feature "user invites friend", {vcr: true, js: true} do
  scenario "user invites a friend and the friend accepted the invitation" do
    clear_emails
    alice = Fabricate(:user)

    user_sign_in(alice)
    invite_a_friend
    user_sign_out

    friend_accepts_invitation

    friend_signs_in
    check_friends_following(alice)
    user_sign_out

    user_sign_in(alice)
    check_users_following
  end

  def invite_a_friend
    visit invite_path
    fill_in "Friend's Name", with: "cathy"
    fill_in "Friend's Email Address", with: "cathy@example.com"
    fill_in "Invitation Message", with: "Join this cool site!"
    click_button "Send Invitation"
    expect(page).to have_content("An invitation has been sent")
  end

  def friend_accepts_invitation
    open_email("cathy@example.com")
    current_email.click_link "sign up here"

    expect(page).to have_content("Register")
    expect(find("#user_email").value).to eq("cathy@example.com")
    fill_in "Password", with: "cathy_password"
    fill_in "Full Name", with: "cathy"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select '8 - August', from: 'date_month'
    select '2017', from: 'date_year'
    click_button "Sign Up"
  end

  def friend_signs_in
    visit sign_in_path
    fill_in "email", with: "cathy@example.com"
    fill_in "password", with: "cathy_password"
    click_button "Sign in"
    expect(page).to have_content "You are signed in!"
  end

  def check_friends_following(inviter)
    click_link "People"
    expect(page).to have_content(inviter.full_name)
  end

  def check_users_following
    click_link "People"
    expect(page).to have_content("cathy")
  end
end
