require "rails_helper"

RSpec.describe User, type: :model do
  it "creates a valid user" do
    user = create(:user)
    expect(user).to be_persisted
  end

  it "nets ledger entries so payment reduces what friend owes you" do
    alice = create(:user, name: "Alice", email: "alice_net@example.com")
    bob   = create(:user, name: "Bob",   email: "bob_net@example.com")

    LedgerEntry.create!(
      from_user: bob,
      to_user: alice,
      amount: 560,
      source_type: "Expense",
      source_id: 1
    )

    expect(alice.net_with(bob.id)).to eq(560.to_d)

    Payment.create!(paid_by: alice, paid_to: bob, amount: 560, notes: "settle")

    expect(alice.net_with(bob.id)).to eq(0.to_d)
    expect(alice.friends_who_owe_you[bob.id]).to be_nil
    expect(alice.friends_you_owe[bob.id]).to be_nil
  end
end
