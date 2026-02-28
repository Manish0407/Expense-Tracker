class Payment < ApplicationRecord
  belongs_to :paid_by
  belongs_to :paid_to
end
