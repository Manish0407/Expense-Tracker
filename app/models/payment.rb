class Payment < ApplicationRecord
  belongs_to :paid_by, class_name: "User"
  belongs_to :paid_to, class_name: "User"

  validates :amount, numericality: { greater_than: 0 }
  validate :cannot_overpay

  after_create :create_settlement_ledger_entry!

  private

  def cannot_overpay
    return if paid_by.nil? || paid_to.nil? || amount.nil?

    max_payable = paid_by.friends_you_owe[paid_to_id].to_d
    if max_payable <= 0
      errors.add(:base, "You do not owe anything to this user")
      return
    end

    if amount.to_d > max_payable
      errors.add(:amount, "cannot be more than #{max_payable}")
    end
  end

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
