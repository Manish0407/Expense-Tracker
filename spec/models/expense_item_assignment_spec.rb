require "rails_helper"

RSpec.describe ExpenseItemAssignment, type: :model do
  let(:user) { create(:user) }

  # Minimal valid expense + item setup
  let(:expense_item) do
    payer = create(:user)

    expense = Expense.new(
      paid_by: payer,
      description: "Test",
      tax_amount: 0,
      spent_on: Date.today
    )

    expense.expense_participants.build(user: payer)

    item = expense.expense_items.build(
      name: "Dummy",
      amount: 10,
      split_type: :assigned
    )

    item.expense_item_assignments.build(user: payer, share_amount: 10)

    expense.save!
    item
  end

  it "is valid when share_amount is nil (equal split case)" do
    assignment = expense_item.expense_item_assignments.new(
      user: user,
      share_amount: nil
    )

    expect(assignment).to be_valid
  end

  it "is invalid when share_amount is 0" do
    assignment = expense_item.expense_item_assignments.new(
      user: user,
      share_amount: 0
    )

    expect(assignment).not_to be_valid
    expect(assignment.errors[:share_amount]).to include("must be > 0")
  end

  it "is invalid when share_amount is negative" do
    assignment = expense_item.expense_item_assignments.new(
      user: user,
      share_amount: -5
    )

    expect(assignment).not_to be_valid
  end

  it "is valid when share_amount is positive" do
    assignment = expense_item.expense_item_assignments.new(
      user: user,
      share_amount: 5
    )

    expect(assignment).to be_valid
  end
end
