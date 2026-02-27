class CreateExpenseParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :expense_participants do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
