require "rails_helper"

RSpec.describe DashboardsController, type: :controller do
  let(:user) { create(:user) }

  before do
    # Stub current_user
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #show" do
    it "returns success" do
      get :show
      expect(response).to have_http_status(:ok)
    end

    it "assigns dashboard variables" do
      get :show

      expect(assigns(:me)).to eq(user)
      expect(assigns(:total_balance)).to eq(user.total_balance)
      expect(assigns(:total_you_owe)).to eq(user.total_you_owe)
      expect(assigns(:total_due_to_you)).to eq(user.total_due_to_you)
      expect(assigns(:friends_i_owe)).to eq(user.friends_you_owe)
      expect(assigns(:friends_owe_me)).to eq(user.friends_who_owe_you)
      expect(assigns(:total_spent_by_all)).to be_a(Numeric)
    end
  end
end
