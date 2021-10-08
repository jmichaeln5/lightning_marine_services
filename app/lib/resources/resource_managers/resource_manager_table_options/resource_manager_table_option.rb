autoload :IndepentTableOption, "services/table_options/independent_table_option.rb"

module ResourceManagerTableOption
  extend IndepentTableOption

  def self.new_table_option(user, parent_class, action, page)
    IndepentTableOption::TableOptionKlass.new(user, parent_class, action, page)
  end

end
