require 'rails_helper'

RSpec.describe Order, type: :model do
  it "Passes initial acceptance test" do
    expect(true).to eq true
  end

  it "can create a valid order" do
    order = create(:order)
    expect(order).to be_valid
  end
end
