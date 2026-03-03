class PaymentsController < ApplicationController
  def new
    @payment = Payment.new
    @users = User.where.not(id: current_user.id).order(:name)
  end

  def create
    @payment = Payment.new(payment_params)
    @users = User.where.not(id: current_user.id).order(:name)

    # enforce current user as payer
    @payment.paid_by = current_user

    if @payment.save
      redirect_to root_path, notice: "Payment recorded successfully"
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:paid_to_id, :amount, :notes)
  end
end
