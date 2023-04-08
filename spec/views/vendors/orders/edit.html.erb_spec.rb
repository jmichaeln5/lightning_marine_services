require 'rails_helper'

RSpec.describe "vendors/orders/edit", type: :view do
  let(:vendors_order) {
    Vendors::Order.create!()
  }

  before(:each) do
    assign(:vendors_order, vendors_order)
  end

  it "renders the edit vendors_order form" do
    render

    assert_select "form[action=?][method=?]", vendors_order_path(vendors_order), "post" do
    end
  end
end
