class DataTable
  attr_reader :klass, :records
  attr_reader :table_headers, :sortable_table_headers

  attr_accessor :title, :sortable_table_headers


  delegate_missing_to :klass

  def initialize(klass = nil, records = nil)
    @klass = klass
    @records = records
  end

  def model_name_element
    klass.model_name.element
  end

  def model_name_collection
    klass.model_name.collection
  end
end
