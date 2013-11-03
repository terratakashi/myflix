require "spec_helper"

feature "User interacts with the queue" do
  scenario "user adds and reorder videos in the queue" do
    categories = [Fabricate(:category)]
    video1 = Fabricate(:video, categories: categories)
    video2 = Fabricate(:video, categories: categories)
    video3 = Fabricate(:video, categories: categories)

    user_sign_in
    find("a[href='#{video_path(video1)}']").click
    expect(page).to have_content(video1.title)

    click_link("+ My Queue")
    expect(page).to have_content(video1.title)

    click_link(video1.title)
    expect(page).not_to have_content("+ My Queue")

    visit home_path
    find("a[href='#{video_path(video2)}']").click
    click_link("+ My Queue")
    visit home_path
    find("a[href='#{video_path(video3)}']").click
    click_link("+ My Queue")


  end
end
