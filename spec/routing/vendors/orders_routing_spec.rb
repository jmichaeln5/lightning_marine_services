require "rails_helper"

RSpec.describe Vendors::OrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/vendors/orders").to route_to("vendors/orders#index")
    end

    it "routes to #new" do
      expect(get: "/vendors/orders/new").to route_to("vendors/orders#new")
    end

    it "routes to #show" do
      expect(get: "/vendors/orders/1").to route_to("vendors/orders#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/vendors/orders/1/edit").to route_to("vendors/orders#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/vendors/orders").to route_to("vendors/orders#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/vendors/orders/1").to route_to("vendors/orders#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/vendors/orders/1").to route_to("vendors/orders#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/vendors/orders/1").to route_to("vendors/orders#destroy", id: "1")
    end
  end
end
