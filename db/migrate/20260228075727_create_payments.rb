class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :paid_by, null: false, foreign_key: { to_table: :users }
      t.references :paid_to, null: false, foreign_key: { to_table: :users }
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.text :notes

      t.timestamps
    end
  end
end
