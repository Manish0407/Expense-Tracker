require "rails_helper"

RSpec.describe ExpenseParticipant, type: :model do
  let(:user) { create(:user) }
  let(:payer) { create(:user) }

  let(:expense) do
    e = Expense.new(
      paid_by: payer,
      description: "Test Expense",
      tax_amount: 0,
      spent_on: Date.today
    )

    # Expense ko valid banane ke liye at least 1 participant + 1 item chahiye
    e.expense_participants.build(user: payer)

    item = e.expense_items.build(
      name: "Dummy",
      amount: 10,
      split_type: :assigned
    )

    item.expense_item_assignments.build(user: payer, share_amount: 10)

    e.save!
    e
  end

  it "is valid with valid attributes" do
    participant = ExpenseParticipant.new(user: user, expense: expense)
    expect(participant).to be_valid
  end

  it "does not allow same user twice for same expense" do
    ExpenseParticipant.create!(user: user, expense: expense)

    duplicate = ExpenseParticipant.new(user: user, expense: expense)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:user_id]).to include("has already been taken")
  end

  it "allows same user in different expenses" do
    ExpenseParticipant.create!(user: user, expense: expense)

    new_expense = Expense.new(
      paid_by: payer,
      description: "Another Expense",
      tax_amount: 0,
      spent_on: Date.today
    )

    new_expense.expense_participants.build(user: payer)

    item = new_expense.expense_items.build(
      name: "Dummy",
      amount: 10,
      split_type: :assigned
    )

    item.expense_item_assignments.build(user: payer, share_amount: 10)

    new_expense.save!

    participant = ExpenseParticipant.new(user: user, expense: new_expense)

    expect(participant).to be_valid
  end
end
