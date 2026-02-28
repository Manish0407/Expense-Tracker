require "rails_helper"

RSpec.describe ExpenseItem, type: :model do
  let(:payer) { create(:user) }

  # Create a VALID expense (participants + at least one valid item) so Expense validations pass
  let(:expense) do
    e = Expense.new(paid_by: payer, description: "Test", tax_amount: 0, spent_on: Date.today)
    e.expense_participants.build(user: payer)

    dummy = e.expense_items.build(name: "Dummy", amount: 1, split_type: :assigned)
    dummy.expense_item_assignments.build(user: payer, share_amount: 1)

    e.save!
    e
  end

  it "assigned item gives full amount to one user" do
    alice = create(:user)

    item = expense.expense_items.new(name: "Juice", amount: 100, split_type: :assigned)
    item.expense_item_assignments.build(user: alice, share_amount: 100) # safe for your validation
    item.save!

    shares = item.user_shares
    expect(shares[alice.id]).to eq(100.to_d)
  end

  it "shared item splits equally when share_amount not provided" do
    alice = create(:user)
    bob   = create(:user)

    item = expense.expense_items.new(name: "Dish", amount: 100, split_type: :shared)
    item.expense_item_assignments.build(user: alice)
    item.expense_item_assignments.build(user: bob)
    item.save!

    shares = item.user_shares
    expect(shares[alice.id] + shares[bob.id]).to eq(100.to_d)
  end

  it "shared item uses unequal share_amount when provided" do
    alice = create(:user)
    bob   = create(:user)

    item = expense.expense_items.new(name: "Dish", amount: 100, split_type: :shared)
    item.expense_item_assignments.build(user: alice, share_amount: 70)
    item.expense_item_assignments.build(user: bob, share_amount: 30)
    item.save!

    shares = item.user_shares
    expect(shares[alice.id]).to eq(70.to_d)
    expect(shares[bob.id]).to eq(30.to_d)
  end
end
