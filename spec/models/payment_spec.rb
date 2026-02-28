require "rails_helper"

RSpec.describe Payment, type: :model do
  it "creates reverse ledger entry to reduce debt" do
    john  = create(:user, name: "John",  email: "john_pay_test@example.com")
    alice = create(:user, name: "Alice", email: "alice_pay_test@example.com")

    payment = Payment.create!(paid_by: john, paid_to: alice, amount: 40, notes: "settle")

    le = LedgerEntry.find_by(source_type: "Payment", source_id: payment.id)

    expect(le).to be_present
    expect(le.from_user_id).to eq(alice.id) # reverse direction
    expect(le.to_user_id).to eq(john.id)
    expect(le.amount).to eq(40.to_d)
  end
end
