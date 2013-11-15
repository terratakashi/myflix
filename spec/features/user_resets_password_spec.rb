require "spec_helper"

feature "user resets their account password" do
  scenario "user demend a email to link the password reset page" do
    clear_emails
    user = Fabricate(:user, password: "old_password")

    visit root_path
    click_link "Sign In"
    expect(page).not_to have_content(user.full_name)

    click_link "Forgot password?"
    fill_in "email", with: user.email
    click_button "Send Email"
    expect(page).to have_content("We have send an email with instruction to reset your password.")

    open_email(user.email)
    expect(current_email).to have_content user.full_name

    current_email.click_link "reset my password"
    expect(page).to have_content("Reset Your Password")

    fill_in "password", with: "new_password"
    click_button "Reset Password"
    expect(page).to have_content "Your password has been updated successfully! Pleas use new password to sign in!"

    visit sign_in_path
    fill_in "email", with: user.email
    fill_in "password", with: "new_password"
    click_button "Sign in"

    expect(page).to have_content user.full_name
    expect(page).to have_content "You are signed in!"
  end
end
