class User < ApplicationRecord
  # Net balance with a friend:
  # +ve => friend owes you
  # -ve => you owe friend
  def net_with(friend_id)
    owed_to_me = LedgerEntry.where(from_user_id: friend_id, to_user_id: id).sum(:amount).to_d
    i_owe      = LedgerEntry.where(from_user_id: id, to_user_id: friend_id).sum(:amount).to_d
    owed_to_me - i_owe
  end

  # Hash: { friend_id => net_amount } for everyone you've transacted with
  def net_by_friend
    friend_ids = LedgerEntry
      .where("from_user_id = :id OR to_user_id = :id", id: id)
      .pluck(:from_user_id, :to_user_id)
      .flatten
      .uniq - [id]

    friend_ids.index_with { |fid| net_with(fid) }
  end

  def friends_who_owe_you
    net_by_friend.select { |_fid, net| net > 0 }
  end

  def friends_you_owe
    net_by_friend.select { |_fid, net| net < 0 }.transform_values { |v| v.abs }
  end

  def total_due_to_you
    friends_who_owe_you.values.sum.to_d
  end

  def total_you_owe
    friends_you_owe.values.sum.to_d
  end

  def total_balance
    total_due_to_you - total_you_owe
  end
end