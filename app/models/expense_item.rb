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
      # If assignments are present → use them
      if assigns.any?
        has_all = assigns.all? { |x| x.share_amount.present? }

        if has_all
          return assigns.to_h { |x| [x.user_id, x.share_amount.to_d] }
        else
          user_ids = assigns.map(&:user_id)
        end
      else
        # If no assignments → use expense participants
        user_ids = expense.expense_participants.pluck(:user_id)
      end

      return {} if user_ids.blank?

      per = (amount.to_d / user_ids.size).round(2)
      shares = user_ids.index_with { per }

      remainder = amount.to_d - (per * user_ids.size)
      shares[user_ids.first] += remainder if remainder != 0

      shares

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
  end
end
