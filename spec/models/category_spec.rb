require "spec_helper"

describe Category do

  it { should have_many(:categories_videos) }

  it { should have_many(:videos).through(:categories_videos) }

  it { should validate_presence_of(:name) }

  it { should validate_uniqueness_of(:name) }

  describe "#recent_videos" do
    it "returns empty array if there is no video in the category" do
      comedy = Category.create(:name => "comedy")

      expect(comedy.recent_videos).to eq([])
    end

    it "returns videos by reverse order of created_at" do
      comedy = Category.create(:name => "comedy")
      titanic = comedy.videos.create(:title => "Titanic", :description => "Awesome", :created_at => 1.day.ago)
      batman  = comedy.videos.create(:title => "Batman", :description => "My favorite")

      expect(comedy.recent_videos).to eq([batman, titanic])
    end

    it "returns all videos if there are less 6" do
      comedy = Category.create(:name => "comedy")
      titanic = comedy.videos.create(:title => "Titanic", :description => "Awesome", :created_at => 2.day.ago)
      batman = comedy.videos.create(:title => "Batman", :description => "My favorite", :created_at => 1.day.ago)
      superman = comedy.videos.create(:title => "Superman", :description => "Real hero")

      expect(comedy.recent_videos).to eq([superman, batman, titanic])
    end

    it "returns 6 recent videos by if there are over 6 videos" do
      comedy = Category.create(:name => "comedy")
      10.times { |i| batman = comedy.videos.create(:title => "Batman#{i}", :description => "Awesome") }

      expect(comedy.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      comedy = Category.create(:name => "comedy")
      10.times { |i| batman = comedy.videos.create(:title => "Batman#{i}", :description => "Awesome") }
      old_fashion = comedy.videos.create(:title => "Old Fashopn", :description => "Bad", :created_at => 1.day.ago)

      expect(comedy.recent_videos).not_to include(old_fashion)
    end
  end
end
