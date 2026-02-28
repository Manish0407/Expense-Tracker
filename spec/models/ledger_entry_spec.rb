require "rails_helper"

RSpec.describe LedgerEntry, type: :model do
  let(:from_user) { create(:user) }
  let(:to_user)   { create(:user) }

  it "is valid with positive amount" do
    entry = LedgerEntry.new(
      from_user: from_user,
      to_user: to_user,
      amount: 10,
      source_type: "Expense",
      source_id: 1
    )

    expect(entry).to be_valid
  end

  it "is invalid with zero amount" do
    entry = LedgerEntry.new(
      from_user: from_user,
      to_user: to_user,
      amount: 0
    )

    expect(entry).not_to be_valid
    expect(entry.errors[:amount]).to be_present
  end

  it "is invalid with negative amount" do
    entry = LedgerEntry.new(
      from_user: from_user,
      to_user: to_user,
      amount: -5
    )

    expect(entry).not_to be_valid
    expect(entry.errors[:amount]).to be_present
  end
end
