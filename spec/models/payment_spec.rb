require "rails_helper"

RSpec.describe Payment, type: :model do
  it "creates reverse ledger entry to reduce debt" do
    john  = create(:user)
    alice = create(:user)

    # john owes alice 100
    LedgerEntry.create!(from_user: john, to_user: alice, amount: 100, source_type: "Expense", source_id: 1)

    payment = Payment.create!(paid_by: john, paid_to: alice, amount: 40, notes: "settle")

    le = LedgerEntry.find_by(source_type: "Payment", source_id: payment.id)
    expect(le).to be_present

    expect(le.from_user_id).to eq(payment.paid_to_id)
    expect(le.to_user_id).to eq(payment.paid_by_id)
    expect(le.amount.to_d).to eq(40.to_d)

    expect(john.friends_you_owe[alice.id]).to eq(60.to_d)
  end
end
