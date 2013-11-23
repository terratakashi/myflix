require "spec_helper"

feature "admin adds a new video" do
  scenario "admin adds a video successfully" do
    Fabricate(:category, name: "movie")

    admin_sign_in
    visit new_admin_video_path

    fill_in :video_title, with: "new batman"
    check('movie')
    fill_in :video_description, with: "it's the newest series"
    attach_file(:video_large_cover, 'public/tmp/monk_large.jpg')
    attach_file(:video_small_cover, 'public/tmp/monk.jpg')
    fill_in :video_video_url, with: "http://example.com/example.mp4"
    click_button "Add Video"

    expect(page).to have_content("created successfully!")
    user_sign_out

    user_sign_in
    find(:xpath, "//img[@src='/uploads/monk.jpg']/..").click
    expect(page).to have_content("new batman")
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://example.com/example.mp4']")
  end
end
