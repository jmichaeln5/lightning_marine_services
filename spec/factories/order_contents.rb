FactoryBot.define do
  factory :order_content do
    # order { association :order }

    box { rand(1..15) }
    crate { rand(1..10) }
    pallet { rand(1..15) }
  end
end
