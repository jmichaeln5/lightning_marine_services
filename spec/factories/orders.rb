order_dept = ["deck", "hull", "nav bridge", "bridge", "cargo hood", "forecastle", "upper hold", "upper deck", "main deck", "derrick", "deckhouse", "3 hold", "chain locker"].sample
order_po_number = Faker::Number.unique.within(range: 1000..9999999999)
order_courrier = ['Fedex', 'UPS', 'USPS', 'DHL'].sample
order_tracking_number = Faker::Number.unique.within(range: 1000..9999999999)

order_delivery_date = Faker::Date.between(from: '2017-01-23', to: Time.now)
order_recieval_date = Faker::Date.between(from: order_delivery_date.prev_month, to: order_delivery_date)

order_date_delivered = order_delivery_date
order_date_recieved = order_recieval_date

FactoryBot.define do

  factory :order do
    dept { order_dept }
    po_number { order_po_number }
    courrier { order_courrier }
    date_recieved { order_date_recieved }
    date_delivered { order_date_delivered }
    tracking_number { order_tracking_number }
    association :purchaser, factory: [:purchaser]
    association :vendor, factory: [:vendor]
    association :order_content, factory: [:order_content]

    factory :valid_order do
      purchaser { create(:purchaser) }
      vendor { create(:vendor) }
      order_content { build(:order_content) }
    end
  end

end
