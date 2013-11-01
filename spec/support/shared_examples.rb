shared_examples "requires sign in" do
  it "redirects to the sign in page" do
    user_sign_out
    action
    expect(response).to redirect_to sign_in_path
  end
end
