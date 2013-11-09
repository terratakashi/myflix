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

  describe "delete #destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to people page" do
      set_current_user
      relationship = Fabricate(:relationship, follower: current_user)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "delete the relationship if current user is follower" do
      set_current_user
      relationship = Fabricate(:relationship, follower: current_user)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    it "does not delete the relationship if current user is not follower" do
      set_current_user
      other_user = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: other_user)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end

  describe "post #create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 1 }
    end

    it "redirects to people page" do
      set_current_user
      other_user = Fabricate(:user)
      post :create, leader_id: other_user
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that current user follows the leader" do
      set_current_user
      bob = Fabricate(:user)
      post :create, leader_id: bob
      expect(current_user.following_relationships.first.leader).to eq(bob)
    end

    it "does not create a relationship if current user already follows the leader" do
      set_current_user
      bob = Fabricate(:user)
      Fabricate(:relationship, follower: current_user, leader: bob)
      post :create, leader_id: bob
      expect(Relationship.count).to eq(1)
    end

    it "does not allow user to follow themselves" do
      set_current_user
      post :create, leader_id: current_user
      expect(Relationship.count).to eq(0)
    end
  end
end
