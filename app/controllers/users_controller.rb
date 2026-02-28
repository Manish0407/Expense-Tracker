class UsersController < ApplicationController
  def index
    @users = User.order(:name)
  end

  def show
    @user = User.find(params[:id])
    @expenses = Expense.where(paid_by_id: @user.id).order(created_at: :desc)
  end
end
