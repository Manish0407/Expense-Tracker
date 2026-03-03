require "rails_helper"

RSpec.describe PaymentsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:other_user)   { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET #new" do
    it "assigns a new payment" do
      # current_user owes other_user 100
      LedgerEntry.create!(from_user: current_user, to_user: other_user, amount: 100, source_type: "Expense", source_id: 1)
      get :new
      expect(response).to have_http_status(:ok)
      expect(assigns(:payment)).to be_a_new(Payment)
      expect(assigns(:users)).to include(other_user)
    end
  end

  describe "POST #create" do
    it "creates payment with current_user as payer" do
      LedgerEntry.create!(from_user: current_user, to_user: other_user, amount: 100, source_type: "Expense", source_id: 1)
      expect {
        post :create, params: {
          payment: {
            paid_to_id: other_user.id,
            amount: 100,
            notes: "settle"
          }
        }
      }.to change(Payment, :count).by(1)

      payment = Payment.last
      expect(payment.paid_by).to eq(current_user)
      expect(payment.paid_to).to eq(other_user)
      expect(response).to redirect_to(root_path)
    end

    it "renders new if invalid" do
      post :create, params: {
        payment: {
          paid_to_id: other_user.id,
          amount: 0
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
