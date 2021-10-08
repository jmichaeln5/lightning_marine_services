autoload :Sort, "services/sorts/sort.rb"

module ResourceManagerSort
  extend Sort

  def self.new_sort(resource, target, sort_option, sort_direction)
    Sort::SortKlass.new(resource, target, sort_option, sort_direction)
  end

end
