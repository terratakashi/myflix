require "spec_helper"

describe RelationshipsController do
  describe "get #index" do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "sets @relationships for current user's following relationships" do
      set_current_user
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: current_user, leader: bob)

      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
  end

end
