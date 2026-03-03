class ExpenseItemAssignment < ApplicationRecord
  belongs_to :expense_item
  belongs_to :user

  validate :share_amount_positive_if_present

  private

  def share_amount_positive_if_present
    return if share_amount.nil? || share_amount == ""
    errors.add(:share_amount, "must be > 0") if share_amount.to_d <= 0
  end
end
