require "spec_helper"

describe QueueItem do

  it { should belong_to(:user) }

  it { should belong_to(:video) }

  describe "#video_title" do
    it "return the title of the associated video" do
      video = Fabricate(:video, title: "batman")
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.video_title).to eq("batman")
    end
  end

  describe "#rating" do
    it "return rating from with review if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 5)
      queue_item = Fabricate(:queue_item, video: video, user: user)

      expect(queue_item.rating).to eq(5)
    end

    it "retun nil if the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)

      expect(queue_item.rating).to be_nil
    end
  end

  describe "#categories" do
    it "return category names of the associated video" do
      category = Fabricate(:category)
      video = Fabricate(:video, categories: [category])
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.categories).to eq([category])
    end
  end
end
