class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.references :paid_by, null: false, foreign_key: { to_table: :users }
      t.string :description
      t.decimal :tax_amount, precision: 10, scale: 2, null: false, default: 0.0
      t.date :spent_on

      t.timestamps
    end
  end
end
