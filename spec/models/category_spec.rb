require "spec_helper"

describe Category do 

  it "normal record save" do
    Category.create(:name => "TV Commercial")
    category = Category.first
    category.name.should == "TV Commercial"
  end

  it "has many videos" do
    Video.create(:title => "Dog")
    Video.create(:title => "Cat")
    category = Category.create(:name => "TV Commercial")
    Video.first.categories << category
    Video.last.categories << category
    # Check both video exists
    category = Category.first
    # => First video
    video = category.videos.first
    video.title.should == "Dog"
    # => Last video
    video = category.videos.last
    video.title.should == "Cat"
  end
    


end