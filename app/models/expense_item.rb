class ExpenseItem < ApplicationRecord
  belongs_to :expense
  has_many :expense_item_assignments, dependent: :destroy

  enum split_type: { assigned: 0, shared: 1 }

  accepts_nested_attributes_for :expense_item_assignments, allow_destroy: true

  validates :name, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :split_type, presence: true
end