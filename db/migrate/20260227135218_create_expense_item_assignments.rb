class CreateExpenseItemAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :expense_item_assignments do |t|
      t.references :expense_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :share_amount, precision: 10, scale: 2, null: false, default: 0.0

      t.timestamps
    end
  end
end
