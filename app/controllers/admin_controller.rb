class AdminController < ApplicationController
  def clear_all_data
    ExpenseItemAssignment.delete_all
    ExpenseItem.delete_all
    ExpenseParticipant.delete_all
    LedgerEntry.delete_all
    Payment.delete_all
    Expense.delete_all

    render plain: "All expense-related data deleted successfully."
  end
end
