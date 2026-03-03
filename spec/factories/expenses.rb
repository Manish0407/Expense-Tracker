FactoryBot.define do
  factory :expense do
    association :paid_by, factory: :user
    description { "Dinner" }
    tax_amount { 0 }
    spent_on { Date.today }
  end
end
