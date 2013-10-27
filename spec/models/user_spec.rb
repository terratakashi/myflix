require "spec_helper"

describe User do

  it { should have_many(:queue_items)}

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

end
