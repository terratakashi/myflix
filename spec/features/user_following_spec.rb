require "spec_helper"

feature "user following" do
  scenario "user follows and un follow another user" do
    categories = [Fabricate(:category)]
    video = Fabricate(:video, categories: categories)
    bob = Fabricate(:user)
    Fabricate(:review, video: video, user: bob)

    user_sign_in
    click_on_video_on_home_page(video)

    click_link bob.full_name
    click_link "Follow"
    expect(page).to have_content(bob.full_name)

    unfollow(bob)
    expect(page).not_to have_content(bob.full_name)
  end

  def unfollow(user)
    find(:xpath, "//tr[contains(.,'#{user.full_name}')]//a[@data-method='delete']").click
  end
end
