class CreateExpenseItems < ActiveRecord::Migration[7.1]
  def change
    create_table :expense_items do |t|
      t.references :expense, null: false, foreign_key: true
      t.string :name
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0.0
      t.integer :split_type

      t.timestamps
    end
  end
end
