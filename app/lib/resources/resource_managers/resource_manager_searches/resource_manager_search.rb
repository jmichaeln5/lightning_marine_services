autoload :Search, "services/searches/search.rb"

module ResourceManagerSearch
  extend Search

  def self.manage_search(resource)
    Search.search_resource(resource)
  end

end
