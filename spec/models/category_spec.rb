require "spec_helper"

describe Category do 

  it { should have_many(:categories_videos) }

  it { should have_many(:videos).through(:categories_videos) }

  it { should validate_presence_of(:name) }

end