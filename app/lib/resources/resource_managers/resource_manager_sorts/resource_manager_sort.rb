autoload :Sort, "services/sorts/sort.rb"

module ResourceManagerSort
  extend Sort
  def self.manage_sort(resource)
    Sort.trigger_sort_target(resource)
  end

end
