require "spec_helper"

describe User do

  it { should have_many(:queue_items).order(:position)}

  it { should have_many(:reviews) }

  it { should validate_presence_of :full_name }

  it { should validate_presence_of :email }

  it { should validate_presence_of :password }

  it { should have_secure_password }

  it "return error if email address has been already taken" do
    User.create(full_name: "Bruce Lee", email: "bruce@kongfu.com", password: 'password')
    bruce = User.create(full_name: "Bruce Chen", email: "bruce@kongfu.com", password: 'password')
    expect(bruce).to have(1).errors_on(:email)
  end

  describe "#normalize_queue_item_position" do
    it "return empty array if queue has no item" do
      user = Fabricate(:user)
      expect(user.normalize_queue_item_position).to eq([])
    end

    it "reorder the queue items by their position" do
      user = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, position: 2, user: user)
      queue_item2 = Fabricate(:queue_item, position: 5, user: user)
      queue_item3 = Fabricate(:queue_item, position: 8, user: user)
      user.normalize_queue_item_position

      expect(queue_item1.reload.position).to eq(1)
      expect(queue_item2.reload.position).to eq(2)
      expect(queue_item3.reload.position).to eq(3)
    end
  end

  describe "#queued_video?" do
    it "returns true if video is in the queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(user.queued_video?(video)).to be_true
    end

    it "returns false if viedeo is not in the queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)

      expect(user.queued_video?(video)).to be_false
    end

  end


end