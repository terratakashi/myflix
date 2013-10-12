require "spec_helper"

describe Video do 

  it { should have_many(:categories_videos) } 

  it { should have_many(:categories).through(:categories_videos) } #

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:description)}

  it { should ensure_length_of(:description).is_at_most(1000) }  

  describe "#search_by_title" do
    it "search nil will return nil" do
      Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title(nil)).to eq nil
    end

    it "search blank string will return nil" do
      Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("")).to eq nil
    end

    it "search nonexisting one will return nothing" do
      Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("Adventure")).to eq []
    end

    it "search a unique existing one will return one" do
      video = Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("Titanic")).to eq [video]
    end

    it "search a existing series will return bunch of records" do
      videos = Video.create( [{:title => "Titanic", :description => "Awesome"},
                              {:title => "Titanic II", :description => "Good"}] )
      expect(Video.search_by_title("Titanic")).to eq videos
    end

    it "search by multiple words including a existing one will return one" do
      video = Video.create(:title => "Titanic", :description => "Awesome")
      expect(Video.search_by_title("Batman Cat Titanic")).to eq [video]
    end

    it "search by multiple words including many existing records will return many" do
      videos = Video.create( [{:title => "Titanic", :description => "Awesome"},
                              {:title => "Titanic II", :description => "Good"},
                              {:title => "Batman", :description => "My favorite"}] )
      expect(Video.search_by_title("Titanic Batman Cat")).to eq videos
    end
  end
  
end