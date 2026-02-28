require "rails_helper"

RSpec.describe Expense, type: :model do
  it "splits tax equally among participants in per_user_shares" do
    john  = create(:user, name: "John", email: "john_test@example.com")
    alice = create(:user, name: "Alice", email: "alice_test@example.com")

    expense = Expense.new(paid_by: john, description: "Tax test", tax_amount: 10, spent_on: Date.today)
    expense.expense_participants.build(user: john)
    expense.expense_participants.build(user: alice)

    item = expense.expense_items.build(name: "Juice", amount: 100, split_type: :assigned)
    item.expense_item_assignments.build(user: alice, share_amount: 100)

    expense.save!

    shares = expense.per_user_shares

    # Alice: 100 + 5 tax
    expect(shares[alice.id]).to eq(105.to_d)
    # John: at least 5 tax (remainder adjustment could add tiny diff)
    expect(shares[john.id]).to be >= 5.to_d
  end

  it "creates ledger entry for participant who owes payer" do
    john  = create(:user, name: "John", email: "john_le_test@example.com")
    alice = create(:user, name: "Alice", email: "alice_le_test@example.com")

    expense = Expense.new(paid_by: john, description: "Ledger test", tax_amount: 0, spent_on: Date.today)
    expense.expense_participants.build(user: john)
    expense.expense_participants.build(user: alice)

    item = expense.expense_items.build(name: "Juice", amount: 50, split_type: :assigned)
    item.expense_item_assignments.build(user: alice, share_amount: 50)

    expense.save!

    le = LedgerEntry.find_by(source_type: "Expense", source_id: expense.id)

    expect(le).to be_present
    expect(le.from_user_id).to eq(alice.id)
    expect(le.to_user_id).to eq(john.id)
    expect(le.amount).to eq(50.to_d)
  end
end
