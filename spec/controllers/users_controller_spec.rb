require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    it "returns success and assigns users ordered by name" do
      u2 = create(:user, name: "Bob")
      u1 = create(:user, name: "Alice")

      get :index

      expect(response).to have_http_status(:ok)
      expect(assigns(:users).map(&:name)).to eq(["Alice", "Bob"])
    end
  end

  describe "GET #show" do
    it "returns success and assigns user and their expenses" do
      user = create(:user, name: "John", email: "john_users_spec@example.com")
      other = create(:user)

      # create one valid expense paid by user
      expense = Expense.new(paid_by: user, description: "Dinner", tax_amount: 0, spent_on: Date.today)
      expense.expense_participants.build(user: user)

      item = expense.expense_items.build(name: "Item", amount: 10, split_type: :assigned)
      item.expense_item_assignments.build(user: user, share_amount: 10)

      expense.save!

      # another expense by other user (should not show)
      expense2 = Expense.new(paid_by: other, description: "Other", tax_amount: 0, spent_on: Date.today)
      expense2.expense_participants.build(user: other)

      item2 = expense2.expense_items.build(name: "Item", amount: 10, split_type: :assigned)
      item2.expense_item_assignments.build(user: other, share_amount: 10)

      expense2.save!

      get :show, params: { id: user.id }

      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq(user)
      expect(assigns(:expenses)).to include(expense)
      expect(assigns(:expenses)).not_to include(expense2)
    end
  end
end
