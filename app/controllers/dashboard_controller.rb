class DashboardController < ApplicationController
  layout "stacked_shell"
  before_action :set_page_heading_title

  #  # http://tutorials.jumpstartlab.com/topics/models/facade_pattern.html
  # Keep Controller Skinny!! By creating a new class for Dashboard in Models

  def show
    @archived_orders = Order.archived.order("created_at DESC")
    @unarchived_orders = Order.unarchived.order("created_at DESC")
    @orders = Order.all
  end

  private

    def set_page_heading_title
      @page_heading_title = "Dashboard"
    end

end
