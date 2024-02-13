class SearchesController < ApplicationController
  layout "stacked_shell"

  before_action :ensure_frame_response, only: %i[ index ]

  def index
    @query_str = params[:query]
    model = Order

    @results = search_query_against_model(model, @query_str) if @query_str
    @results = Order.order(created_at: :desc) if (!@query_str or @query_str.empty?)

    @results_amount = @results.size
    @pagy, @results = pagy @results, items: params.fetch(:count, 10)
  end

  private
    def search_query_against_model(model, query_str)
      results = model.search(query_str,
        misspellings: { below: 3},
        fields: Order.searchable_attrs,
      ).results

      model.where(id: results.pluck(:id)).includes(:order_content)
    end
end
