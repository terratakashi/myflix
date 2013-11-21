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

shared_examples "requires admin" do
  it "redirects to home page for regular users" do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end

  it "sets a error message for regular users" do
    set_current_user
    action
    expect(flash[:error]).to be_present
  end
end
