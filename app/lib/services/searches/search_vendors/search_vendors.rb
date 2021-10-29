module SearchVendors

  module SearchVendorsIndex
    autoload :SearchVendorsIndex, "services/searches/search_vendors/search_vendors_index.rb"
    extend SearchVendorsIndex
  end

  module SearchVendorsShow
    autoload :SearchVendorsShow, "services/searches/search_vendors/search_vendors_show.rb"
    extend SearchVendorsShow
  end

end
