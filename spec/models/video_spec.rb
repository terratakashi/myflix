require "spec_helper"

describe Video do

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
      video = Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("Titanic")).to eq [video]
    end

    it "return bunch of records if search a series" do
      videos = Video.create( [{:title => "Titanic", :description => "Awesome"},
                              {:title => "Titanic II", :description => "Good"}] )
      expect(Video.search_by_title("Titanic")).to eq videos
    end

    it "return one if one of multiple words match" do
      video = Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("Batman Cat Titanic")).to eq [video]
    end

    it "return many records if multiple words match multiple records" do
      videos = Video.create( [{:title => "Titanic", :description => "Awesome"},
                              {:title => "Titanic II", :description => "Good"},
                              {:title => "Batman", :description => "My favorite"}] )
      expect(Video.search_by_title("Titanic Batman Cat")).to eq videos
    end
  end

end
