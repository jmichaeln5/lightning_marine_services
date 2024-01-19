module OrdersTableHelper
  extend ActiveSupport::Concern

  def resolve_orders_for_data_table(orders)
    dev_output_str("OrdersTableHelper#resolve_orders_for_data_table")

    orders = filter_orders_by_status if filter_orders_by_status?
    orders = filter_orders_by_courrier if filter_orders_by_courrier?
    orders = sort_orders_against_params(orders) if sort_param.present?
    orders = search_orders_against_query(orders, query_param ) if query_param.present? and query_param.length > 1

    return orders
  end

  def filter_params #  NOTE # CHANGE FORM OBJ ID/NAME TO SUBMIT FILTERS FORM OBJ BEFORE SENDING TO AGGREGATOR/FILTERABLE
    params[:filter]
  end

  def sort_param
    params[:sort]
  end

  def sort_direction
    params[:direction]
  end

  def query_param
    params[:query]
  end

  def filter_orders_by_status?
    return false if params[:status].nil?

    params[:status].to_sym.in? Order.statuses
  end

  def filter_orders_by_courrier?
    return false if params[:courrier].nil?

    courriers = Order.select(:courrier).distinct.map &:courrier
    courriers.map {|_c| _c.downcase!}

    params[:courrier].downcase.in? courriers
  end

  def filter_orders_by_dept?
    return false if params[:dept].nil?

    depts = Order.select(:dept).distinct.map &:dept
    depts.map {|obj| obj.downcase!}

    params[:dept].downcase.in? depts
  end

  private
    def filter_orders_by_status
      Order.where(status: params[:status])
    end

    def filter_orders_by_courrier
      Order.where(courrier: params[:courrier])
    end

    def filter_orders_by_dept
      Order.where(dept: params[:dept])
    end

    def search_orders_against_query(orders, query_str)
      dev_output_str("OrdersTableHelper#search_orders_against_query")

      results = orders.search(query_str, misspellings: { below: 6} ).results
      results_arr = Array.new
      results.each do |result|
        results_arr << result.id if (result.archived? == false)
      end
      orders = orders.where(id: results_arr)
      return orders
    end

    def arel_reorder(sorted_orders_ids_arr)
      dev_output_str("OrdersTableHelper#arel_reorder")

      # https://stackoverflow.com/a/61267426
      order_query = <<-SQL
        CASE orders.id
          #{sorted_orders_ids_arr.map.with_index { |id, index| "WHEN #{id} THEN #{index}" } .join(' ')}
          ELSE #{sorted_orders_ids_arr.length}
        END
      SQL

      newly_sorted_orders = Order.where(id: sorted_orders_ids_arr).order(Arel.sql(order_query))
      clear_active_record_query_cache

      orders = newly_sorted_orders
      return orders
    end

    def reorder_orders_by_sort_params(orders)
      if %w{ id dept date_recieved courrier date_delivered }.include?(sort_param)
        orders.reorder(sort_param => sort_direction)
      else
        orders.order(id: :desc)
      end
    end

    def ordered_order_ids_from_arent_sort_params(orders)
      sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_direction) if sort_param == "ship_name"
      sorted_orders = Order.where(id: orders.ids).filter_by_purchasers(sort_direction) if sort_param == "purchaser_name"
      sorted_orders = Order.where(id: orders.ids).filter_by_vendors(sort_direction) if sort_param == "vendor_name"

      sorted_orders_ids = sorted_orders.ids
      sorted_orders_ids_arr = Array.new
      sorted_orders_ids.each do |order_id|
        sorted_orders_ids_arr << order_id
      end
      orders = arel_reorder(sorted_orders_ids_arr)

      return orders
    end

    def sort_orders_against_params(orders)
      dev_output_str("OrdersTableHelper#sort_orders_against_params")

      if ((sort_param == "ship_name") || ( sort_param == "vendor_name" )) # None Order col
        orders = ordered_order_ids_from_arent_sort_params(orders)
      end

      if ((sort_param != "ship_name") && (sort_param != "purchaser_name") && ( sort_param != "vendor_name" )) # sorting order col
        orders = reorder_orders_by_sort_params(orders)
      end

      return orders
    end
end
