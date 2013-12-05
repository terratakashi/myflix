require "spec_helper"

describe Video do

  it { should have_many(:reviews) }
  it { should have_many(:categories_videos) }
  it { should have_many(:categories).through(:categories_videos) } #
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description)}
  it { should ensure_length_of(:description).is_at_most(1000) }

  describe "#search_by_title" do
    it "return nil if search nil" do
      Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title(nil)).to eq nil
    end

    it "return nil if search blank string" do
      Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("")).to eq nil
    end

    it "return empty if no result match" do
      Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("Adventure")).to eq []
    end

    it "return one if match one" do
      titanic = Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("Titanic")).to eq [titanic]
    end

    it "return records by reverse order of created_at" do
      titanic = Video.create(:title => "Titanic", :description => "Awesome", :created_at => 1.day.ago)
      titanic2 = Video.create(:title => "Titanic II", :description => "Good")
      expect(Video.search_by_title("Titanic")).to eq [titanic2, titanic]
    end

    it "return one if one of multiple words match" do
      titanic = Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("Batman Cat Titanic")).to eq [titanic]
    end

    it "return many records if multiple words match multiple records" do
      titanic = Video.create(:title => "Titanic", :description => "Awesome", :created_at => 2.day.ago)
      titanic2 = Video.create(:title => "Titanic II", :description => "Good", :created_at => 1.day.ago)
      batman = Video.create(:title => "Batman", :description => "My favorite")
      expect(Video.search_by_title("Titanic Batman Cat")).to eq [batman, titanic2, titanic]
    end
  end

  describe "#average_rating" do
    it "return nil if no review in the viedo" do
      video = Fabricate(:video)

      expect(video.average_rating).to be_nil
    end

    it "return average rating of the video" do
      titanic = Fabricate(:video)
      Fabricate(:review, rating: 2, video: titanic)
      Fabricate(:review, rating: 3, video: titanic)

      expect(titanic.average_rating).to eq(2.5)
    end
  end

end
