class DashboardsController < ApplicationController
  def show
    @me = current_user

    @total_balance = @me.total_balance
    @total_you_owe = @me.total_you_owe
    @total_due_to_you = @me.total_due_to_you

    @friends_i_owe = @me.friends_you_owe # { friend_id => amount }
    @friends_owe_me = @me.friends_who_owe_you

    @my_expenses = Expense.where(paid_by_id: @me.id).order(created_at: :desc)
    @total_spent_by_all = Expense.all.sum { |e| e.total_amount }
  end
end
