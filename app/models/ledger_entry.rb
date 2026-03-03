class LedgerEntry < ApplicationRecord
  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"

  validates :amount, numericality: { greater_than: 0 }
end
