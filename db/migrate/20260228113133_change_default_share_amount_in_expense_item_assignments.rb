class ChangeDefaultShareAmountInExpenseItemAssignments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :expense_item_assignments, :share_amount, from: 0, to: nil
    change_column_null :expense_item_assignments, :share_amount, true
  end
end
