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
end
