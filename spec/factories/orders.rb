FactoryBot.define do
  factory :order do
    courrier { ['Fedex', 'UPS', 'USPS', 'DHL'].sample }
    association :purchaser, factory: [:purchaser]
    association :vendor, factory: [:vendor]
    association :order_content, factory: :user
  end

  factory :order_content, parent: :order do
    box { rand(0..15) }
    crate { rand(0..10) }
    pallet { rand(0..15) }
  end
end
