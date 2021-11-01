class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_search_params
  before_action :set_pagination_params
  helper_method :sort_option, :sort_direction
  before_action :load_resource_files
  # before_action :load_resource_files, only: %i[ index all_orders ] # must be after actions/methods that defines @resource (data object) attrs in resource_attrs hash (local var)

  def index
    # resource_attrs = {
    #   user: current_user,
    #   target: @resource.target,
    #   parent_class: @resource.parent_class,
    #   parent_action: @resource.parent_action,
    #   sort_option: sort_option,
    #   sort_direction: sort_direction,
    #   page: @page
    # }
    # @init_resource = Resource.init_resource_klass ( resource_attrs )
    # @resource = Resource::ResourceKlass.get_resource
    # # @orders = @resource.target
    # @resource = @resource.paginated_target

    # load_resource_files

    Resource.reload_ivars

    resource_attrs = {
      user: current_user,
      target: Order.all.unarchived,
      parent_class: Order,
      parent_action: 'index',
      controller_name: 'orders',
      controller_action: 'index',
      controller_name_and_action: 'orders#index',
      search_query: @query,
      sort_option: sort_option,
      sort_direction: sort_direction,
      page: @page
    }

    @init_resource = Resource.init_resource_klass ( resource_attrs )
    @resource = Resource::ResourceKlass.get_resource

    @table_option = @resource.table_option
    @orders = @resource.paginated_target
    @order = Order.new
    @order_content = @order != nil ? @order.build_order_content : OrderContent.new
  end

  private

    def sort_option(sort_option = nil)
      sort_option = params[:sort_option] ||= nil
      return sort_option.to_s
    end

    def sort_direction(sort_direction = nil)
      sort_direction = params[:sort_direction] == "desc" ? "asc" : "desc"
    end

    def set_pagination_params
      @page = params.fetch(:page, 0).to_i
    end

    def load_resource_files
      autoload :ResourceManager, "resources/resource_managers/resource_manager.rb"
      autoload :Resource, "resources/resource.rb"
      Resource.reload_ivars
      ResourceManager.reload_ivars
    end

    def set_search_params
      @query = params[:q]
      @query_parent_class = @resource.parent_class

       if @query.present?
          @resource.parent_class.reindex
          search_query = Order.search(@query)
          results_arr = Array.new
          search_query.results.each do |result|
            results_arr << result.id
          end
        end

      @search_query = @resource.where(id: results_arr)
    end


end
