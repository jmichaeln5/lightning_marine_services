module SearchPurchasers

  module SearchPurchasersIndex
    autoload :SearchPurchasersIndex, "services/searches/search_purchasers/search_purchasers_index.rb"
    extend SearchPurchasersIndex
  end

  module SearchPurchasersShow
    autoload :SearchPurchasersShow, "services/searches/search_purchasers/search_purchasers_show.rb"
    extend SearchPurchasersShow
  end

end
