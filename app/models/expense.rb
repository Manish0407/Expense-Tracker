class Expense < ApplicationRecord
  belongs_to :paid_by, class_name: "User"

  has_many :expense_participants, dependent: :destroy
  has_many :participants, through: :expense_participants, source: :user

  has_many :expense_items, dependent: :destroy

  accepts_nested_attributes_for :expense_participants, allow_destroy: true
  accepts_nested_attributes_for :expense_items, allow_destroy: true
  
  validates :paid_by, presence: true
  validate :must_have_participants
  validate :must_have_items

  after_create :create_ledger_entries!

  def per_user_shares
    shares = Hash.new(0.to_d)

    expense_items.includes(:expense_item_assignments).each do |item|
      item.user_shares.each { |user_id, amt| shares[user_id] += amt }
    end

    # tax split equally among ALL participants
    if tax_amount.to_d > 0 && participants.any?
      per = (tax_amount.to_d / participants.size).round(2)
      participants.each { |u| shares[u.id] += per }

      remainder = tax_amount.to_d - (per * participants.size)
      shares[paid_by_id] += remainder if remainder != 0
    end

    shares
  end

  def total_amount
    expense_items.sum(:amount).to_d + tax_amount.to_d
  end

  private

  def create_ledger_entries!
    LedgerEntry.transaction do
      per_user_shares.each do |user_id, amt|
        next if user_id == paid_by_id
        next if amt <= 0

        LedgerEntry.create!(
          from_user_id: user_id,
          to_user_id: paid_by_id,
          amount: amt,
          source_type: "Expense",
          source_id: id
        )
      end
    end
  end

  def must_have_participants
    errors.add(:base, "Select at least one participant") if participants.empty? && expense_participants.empty?
  end

  def must_have_items
    errors.add(:base, "Add at least one item") if expense_items.empty?
  end
end
