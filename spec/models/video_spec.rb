require "spec_helper"

describe Video do 

  it { should have_many(:categories_videos) } 

  it { should have_many(:categories).through(:categories_videos) } #

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:description)}

  it { should ensure_length_of(:description).is_at_most(1000) }  
  
end