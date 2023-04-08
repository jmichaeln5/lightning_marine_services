require 'rails_helper'

RSpec.describe "vendors/orders/show", type: :view do
  before(:each) do
    assign(:vendors_order, Vendors::Order.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
