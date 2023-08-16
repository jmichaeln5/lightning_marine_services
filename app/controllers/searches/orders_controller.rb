# class Searches::OrdersController < ApplicationController
class Searches::OrdersController < SearchesController

  ### Currently the same as: SearchesController, and not in use (8-14-23)

  layout "stacked_shell"

  before_action :ensure_frame_response, only: %i[ index ]

  def index
    # Create PORO for searching
    @query_str = params[:query]
    model = Order

    @results = search_query_against_model(model, @query_str) if @query_str
    @results = Order.order(created_at: :desc) if (!@query_str or @query_str.empty?)

    @results_amount = @results.size
    @pagy, @results = pagy @results, items: params.fetch(:count, 10)
  end

  private
    def search_query_against_model(model, query_str)
      results = model.search(query_str, misspellings: { below: 3} ).results
      results_arr = Array.new
      results.each do |result|
        results_arr << result.id
      end
      return model.where(id: results_arr)
    end
end
