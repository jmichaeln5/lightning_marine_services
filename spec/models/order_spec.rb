require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:purchaser) { create(:purchaser)}
  let(:vendor) { create(:vendor)}
  let(:order_content) { build(:order_content)}

  let(:dept) { ["deck", "hull", "nav bridge", "bridge", "cargo hood", "forecastle", "upper hold", "upper deck", "main deck", "derrick", "deckhouse", "3 hold", "chain locker"].sample }
  let(:po_number) { Faker::Number.unique.within(range: 1000..9999999999) }
  let(:courrier) { ['Fedex', 'UPS', 'USPS', 'DHL'].sample }
  let(:date_delivered) { Faker::Date.between(from: '2017-01-23', to: Time.now) }
  let(:date_recieved) { Faker::Date.between(from: date_delivered.prev_month, to: date_delivered) }
  let(:tracking_number) { Faker::Number.unique.within(range: 1000..9999999999) }

  let(:order) {
    build(
      :order,
        purchaser_id: purchaser.id,
        vendor_id: vendor.id,
        dept: dept,
        po_number: po_number,
        courrier: courrier,
        date_recieved: date_recieved,
        date_delivered: date_delivered,
        tracking_number: tracking_number,
        order_content: order_content,
    )
  }

  before do
    order.save
  end

  after do
    order.destroy
  end

  it "Passes initial acceptance test" do
    expect(true).to eq true
  end

  it "is a valid user" do
    expect(order.valid?).to be true
  end

end
