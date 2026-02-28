class ExpensesController < ApplicationController
  def new
    @expense = Expense.new(paid_by: current_user, spent_on: Date.today, tax_amount: 0)
    @users = User.order(:name)

    # default: include John + one item + one assignment
    @expense.expense_participants.build(user: current_user)

    item = @expense.expense_items.build(name: "Item 1", amount: 0, split_type: :shared)
    item.expense_item_assignments.build(user: current_user)
  end

  def create
    @expense = Expense.new(expense_params)
    @users = User.order(:name)

    if @expense.save
      redirect_to @expense, notice: "Expense created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @expense = Expense.find(params[:id])
  end

  def index
    @expenses = Expense.includes(:paid_by).order(created_at: :desc)
  end

  private

  def expense_params
    params.require(:expense).permit(
      :paid_by_id, :description, :tax_amount, :spent_on,
      expense_participants_attributes: [:id, :user_id, :_destroy],
      expense_items_attributes: [:id, :name, :amount, :split_type, :_destroy,
        expense_item_assignments_attributes: [:id, :user_id, :share_amount, :_destroy]
      ]
    )
  end
end
