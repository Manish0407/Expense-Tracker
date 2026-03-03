class PaymentsController < ApplicationController
  before_action :build_form_data, only: %i[new create]

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.paid_by = current_user

    if @payment.save
      redirect_to root_path, notice: "Payment recorded successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:paid_to_id, :amount, :notes)
  end

  def build_form_data
    owes_hash = current_user.friends_you_owe # { friend_id => amount }
    friend_ids = owes_hash.keys

    @users = User.where(id: friend_ids).order(:name)
    @max_payable_by_user = @users.each_with_object({}) do |u, h|
      h[u.id] = (owes_hash[u.id] || 0).to_d
    end
  end
end
