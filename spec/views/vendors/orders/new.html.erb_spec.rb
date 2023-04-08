require 'rails_helper'

RSpec.describe "vendors/orders/new", type: :view do
  before(:each) do
    assign(:vendors_order, Vendors::Order.new())
  end

  it "renders new vendors_order form" do
    render

    assert_select "form[action=?][method=?]", vendors_orders_path, "post" do
    end
  end
end
