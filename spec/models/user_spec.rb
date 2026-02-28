require "rails_helper"

RSpec.describe User, type: :model do
  it "creates a valid user" do
    user = create(:user)
    expect(user).to be_persisted
  end
end
