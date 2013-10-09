require "spec_helper"

describe Video do 
  
  it "normal record save correctly" do
    video = Video.new(:title => "Good Title",
                      :description => "Awesome",
                      :small_cover => "small_cover/video.jpg",
                      :large_cover => "large_cover/video_large.jpg")
    video.save
    # Test the title and description
    video = Video.first
    video.title.should == "Good Title"
    video.description.should == "Awesome"
    video.small_cover.should == "small_cover/video.jpg"
    video.large_cover.should == "large_cover/video_large.jpg"
  end
    
  
  
end