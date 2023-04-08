require 'rails_helper'

RSpec.describe "vendors/orders/index", type: :view do
  before(:each) do
    assign(:vendors_orders, [
      Vendors::Order.create!(),
      Vendors::Order.create!()
    ])
  end

  it "renders a list of vendors/orders" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
