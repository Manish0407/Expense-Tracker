require "rails_helper"

RSpec.describe ExpensesController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #new" do
    it "assigns a new expense" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(assigns(:expense)).to be_a_new(Expense)
      expect(assigns(:users)).to be_present
    end
  end

  describe "GET #index" do
    it "returns success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns success" do
      expense = create_valid_expense(user)
      get :show, params: { id: expense.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    it "creates expense with valid params" do
      expect {
        post :create, params: valid_expense_params(user)
      }.to change(Expense, :count).by(1)

      expect(response).to redirect_to(Expense.last)
    end

    it "renders new when invalid" do
      post :create, params: { expense: { description: "" } }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  # ---- Helpers ----

  def create_valid_expense(payer)
    expense = Expense.new(
      paid_by: payer,
      description: "Test",
      tax_amount: 0,
      spent_on: Date.today
    )

    expense.expense_participants.build(user: payer)

    item = expense.expense_items.build(
      name: "Item",
      amount: 10,
      split_type: :assigned
    )

    item.expense_item_assignments.build(user: payer, share_amount: 10)

    expense.save!
    expense
  end

  def valid_expense_params(payer)
    {
      expense: {
        paid_by_id: payer.id,
        description: "Dinner",
        tax_amount: 0,
        spent_on: Date.today,
        expense_participants_attributes: [
          { user_id: payer.id }
        ],
        expense_items_attributes: [
          {
            name: "Juice",
            amount: 50,
            split_type: "assigned",
            expense_item_assignments_attributes: [
              { user_id: payer.id, share_amount: 50 }
            ]
          }
        ]
      }
    }
  end
end
