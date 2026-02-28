class User < ApplicationRecord
  def total_due_to_you
    LedgerEntry.where(to_user_id: id).sum(:amount).to_d
  end

  def total_you_owe
    LedgerEntry.where(from_user_id: id).sum(:amount).to_d
  end

  def total_balance
    total_due_to_you - total_you_owe
  end

  def friends_who_owe_you
    LedgerEntry.where(to_user_id: id).group(:from_user_id).sum(:amount)
  end

  def friends_you_owe
    LedgerEntry.where(from_user_id: id).group(:to_user_id).sum(:amount)
  end
end
