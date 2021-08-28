class ExportsController < ApplicationController
  before_action :authenticate_user!


  def index
    @orders = Order.all.order("created_at DESC")
    @vendors = Vendor.all.order("created_at DESC")
    @purchasers = Purchaser.all.order("created_at DESC")

    @form_data

    # case current_page
    #
    #   when 'orders#index'
    #     resource_path = orders_path
    #   when 'orders#show'
    #     resource_path = order_path(@order)
    #
    #
    #   when 'purchasers#index'
    #     resource_path = purchasers_path
    #   when 'purchasers#show'
    #     resource_path = purchaser_path(@purchaser)
    #
    #
    #   when 'vendors#index'
    #     resource_path = vendors_path
    #   when 'vendors#show'
    #     resource_path = vendor_path(@vendor)
    # end
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"orders-list\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end



  def sample_page

  end










  def export_csv
    @orders = Order.all.order("created_at DESC")
    @vendors = Vendor.all.order("created_at DESC")
    @purchasers = Purchaser.all.order("created_at DESC")

    # case current_page
    #
    #   when 'orders#index'
    #     resource_path = orders_path
    #   when 'orders#show'
    #     resource_path = order_path(@order)
    #
    #
    #   when 'purchasers#index'
    #     resource_path = purchasers_path
    #   when 'purchasers#show'
    #     resource_path = purchaser_path(@purchaser)
    #
    #
    #   when 'vendors#index'
    #     resource_path = vendors_path
    #   when 'vendors#show'
    #     resource_path = vendor_path(@vendor)
    # end
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"#{resource.to_s}-list\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

end
