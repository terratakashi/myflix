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
                      :description => "Awesome")
    Category.first.videos << video
    Category.last.videos << video
    # Check both categories exists
    video = Video.first
    # => First category
    category = video.categories.first
    category.name.should == "TV"
    # => Last category
    category = video.categories.last
    category.name.should == "Radio"
  end

  it "title can't be blank" do 
    video = Video.new(:title => nil,
                      :description => "Awesome")
    # Check if nil title would pass the validation
    video.save.should == false
  end

  it "description can't be blank" do
    video = Video.new(:title => "Good Title", 
                      :description => nil)
    # Check if nil would pass the validation
    video.save.should == false
  end

  it "description is too long" do
    long_text = "longtext"
    1000.times {long_text += "t" } 
    video = Video.new(:title => "Good Title", :description => long_text)
    # Check if description is over maximum limit
    video.save.should == false
  end
  
  
end