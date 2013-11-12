require 'spec_helper'

describe Review do

  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :rating }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video)
      review = Fabricate(:review, video: video)

      expect(review.video_title).to eq(video.title)
    end
  end
end
