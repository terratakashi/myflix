require "spec_helper"

feature "User signs in" do
  given(:alex) { User.create(full_name:"alex chen", password: "password", email: "alex@example.com") }

  scenario "Signing in with correct credentials" do
    visit sign_in_path
    fill_in "email", with: alex.email
    fill_in "password", with: alex.password
    click_button "Sign in"

    expect(page).to have_content alex.full_name
    expect(page).to have_content "You are signed in!"
  end

  scenario "Signing in as incorrect credentials" do
    visit sign_in_path
    fill_in "email", with: "bob@example.com"
    fill_in "password", with: "password"
    click_button "Sign in"

    expect(page).not_to have_content alex.full_name
    expect(page).to have_content "Incorrect email or password. Please try again."
  end
end
