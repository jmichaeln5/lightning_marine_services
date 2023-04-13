class SearchesController < ApplicationController
  layout "stacked_shell"

  def index
    query_str = params[:query]
    model = Order

    @results = search_query_against_model(model, query_str) if query_str
    @results = Order.order(created_at: :desc) if !query_str

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
