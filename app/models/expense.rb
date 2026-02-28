class Expense < ApplicationRecord
  belongs_to :paid_by, class_name: "User"

  has_many :expense_participants, dependent: :destroy
  has_many :participants, through: :expense_participants, source: :user

  has_many :expense_items, dependent: :destroy

  accepts_nested_attributes_for :expense_participants, allow_destroy: true
  accepts_nested_attributes_for :expense_items, allow_destroy: true

  validates :paid_by, presence: true
end
