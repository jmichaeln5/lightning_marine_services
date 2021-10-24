module SortVendors

  module SortIndex
    autoload :SortIndex, "services/sorts/sort_vendors/sort_index.rb"
    extend SortIndex
  end

  module SortShow
    autoload :SortShow, "services/sorts/sort_vendors/sort_show.rb"
    extend SortShow
  end
  
end
