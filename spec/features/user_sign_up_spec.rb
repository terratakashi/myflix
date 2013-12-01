require "spec_helper"

feature "user sign up", {js: true, vcr: true} do
  background do
    visit register_path
  end

  scenario "with valid user info and valid card" do
    cathy = Fabricate.build(:user)

    visit register_path
    fill_in_user_field(cathy)
    fill_in_credit_card_field("4242424242424242")
    click_button "Sign Up"

    expect(page).to have_content("The acoount of #{cathy.full_name} has been created.")
  end

  scenario "with valid user info and declined card" do
    cathy = Fabricate.build(:user)

    fill_in_user_field(cathy)
    fill_in_credit_card_field("4000000000000002")
    click_button "Sign Up"

    expect(page).to have_content("Your card was declined.")
  end

  scenario "with valid user info and invalid card" do
    cathy = Fabricate.build(:user)

    fill_in_user_field(cathy)
    fill_in_credit_card_field("123123")
    click_button "Sign Up"

    expect(page).to have_content("This card number looks invalid")
  end

  scenario "with invalid user info and valid card" do
    invalid_user = User.new(email: "test_user@example.com")

    fill_in_user_field(invalid_user)
    fill_in_credit_card_field("4242424242424242")
    click_button "Sign Up"

    expect(page).to have_content("Invalid user informaiton. Please check the errors below.")
  end

  scenario "with invalid user info and declined card" do
    invalid_user = User.new(email: "test_user@example.com")

    fill_in_user_field(invalid_user)
    fill_in_credit_card_field("4000000000000002")
    click_button "Sign Up"

    expect(page).to have_content("Invalid user informaiton. Please check the errors below.")
  end

  scenario "with invalid user info and invalid card" do
    invalid_user = User.new(email: "test_user@example.com")

    fill_in_user_field(invalid_user)
    fill_in_credit_card_field("123123")
    click_button "Sign Up"

    expect(page).to have_content("This card number looks invalid")
  end

  def fill_in_user_field(user)
    fill_in "Email Address", with: user.email
    fill_in "Password", with: user.password
    fill_in "Full Name", with: user.full_name
  end

  def fill_in_credit_card_field(card_number)
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: "123"
    select '8 - August', from: 'date_month'
    select '2017', from: 'date_year'
  end
end
