class Payment < ApplicationRecord
  belongs_to :paid_by, class_name: "User"
  belongs_to :paid_to, class_name: "User"

  validates :amount, numericality: { greater_than: 0 }

  after_create :create_settlement_ledger_entry!

  private

  # reverse entry to reduce paid_by's debt to paid_to
  def create_settlement_ledger_entry!
    LedgerEntry.create!(
      from_user_id: paid_to_id,
      to_user_id: paid_by_id,
      amount: amount,
      source_type: "Payment",
      source_id: id
    )
  end
end
