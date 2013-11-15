shared_examples "requires sign in" do
  it "redirects to the sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "requires a valid token" do
  it "redirects to the invalid token page" do
    action
    expect(response).to redirect_to invalid_token_path
  end
end
