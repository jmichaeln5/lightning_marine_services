FactoryBot.define do
  factory :order_content do
    box { rand(1..15) }
    crate { rand(1..10) }
    pallet { rand(1..15) }
  end
end
