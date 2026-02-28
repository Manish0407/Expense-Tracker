class ExpenseItem < ApplicationRecord
  belongs_to :expense
  has_many :expense_item_assignments, dependent: :destroy

  enum split_type: { assigned: 0, shared: 1 }

  accepts_nested_attributes_for :expense_item_assignments, allow_destroy: true

  validates :name, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :split_type, presence: true

  validate :validate_assignment_rules

  def user_shares
    assigns = expense_item_assignments.to_a

    case split_type
    when "assigned"
      a = assigns.first
      return {} if a.nil?
      { a.user_id => amount.to_d }

    when "shared"
      return {} if assigns.empty?

      if assigns.any? { |x| x.share_amount.present? }
        # unequal: use share_amount
        assigns.to_h { |x| [x.user_id, x.share_amount.to_d] }
      else
        # equal
        per = (amount.to_d / assigns.size).round(2)
        shares = assigns.to_h { |x| [x.user_id, per] }
        remainder = amount.to_d - (per * assigns.size)
        shares[assigns.first.user_id] += remainder if remainder != 0
        shares
      end
    else
      {}
    end
  end

  private

  def validate_assignment_rules
    assigns = expense_item_assignments.to_a

    if assigned?
      errors.add(:base, "Assigned item must have exactly 1 person") if assigns.size != 1
    end

    if shared?
      errors.add(:base, "Shared item must have at least 1 person") if assigns.empty?

      if assigns.any? { |x| x.share_amount.present? }
        total = assigns.sum { |x| (x.share_amount || 0).to_d }
        errors.add(:base, "Unequal shares must sum to item amount") if total != amount.to_d
      end
    end
  end
end