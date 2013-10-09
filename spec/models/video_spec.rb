require "spec_helper"

describe Video do 

  it "normal record save correctly" do
    Video.create(:title => "Good Title",
                 :description => "Awesome",
                 :small_cover => "small_cover/video.jpg",
                 :large_cover => "large_cover/video_large.jpg")
    # Check consistency of all attritutes
    video = Video.first
    video.title.should == "Good Title"
    video.description.should == "Awesome"
    video.small_cover.should == "small_cover/video.jpg"
    video.large_cover.should == "large_cover/video_large.jpg"
  end
    
  it "has many categories" do
    Category.create(:name => "TV")
    Category.create(:name => "Radio")
    video = Video.create(:title => "Good Title",
                      :description => "Awesome",
                      :small_cover => "small_cover/video.jpg",
                      :large_cover => "large_cover/video_large.jpg")
    Category.first.videos << video
    Category.last.videos << video
    # Check both categories exists
    video = Video.first
    category = video.categories.first
    category.name.should == "TV"
    category = video.categories.last
    category.name.should == "Radio"

  end
  
  
end