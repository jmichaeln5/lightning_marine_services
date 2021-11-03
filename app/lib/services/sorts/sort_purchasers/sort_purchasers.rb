module SortPurchasers

  module SortIndex
    autoload :SortIndex, "services/sorts/sort_purchasers/sort_index.rb"
    extend SortIndex
  end

  module SortShow
    autoload :SortShow, "services/sorts/sort_purchasers/sort_show.rb"
    extend SortShow
  end

end
