require "spec_helper"

describe Invitation do
  it { should belong_to(:inviter) }
  it { should validate_presence_of :recipient_name }
  it { should validate_presence_of :recipient_email }
  it { should validate_presence_of :message }

  it "generate a token when the invitation created" do
    invitation = Fabricate(:invitation)
    expect(invitation.token).to be_present
  end
end
