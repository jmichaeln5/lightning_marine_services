# frozen_string_literal: true

module Pagination
end

# load Kaminari components
require 'pagination/pagination_core'
require 'pagination/exceptions'
require 'pagination/helpers/paginator'
require 'pagination/models/page_scope_methods'
require 'pagination/models/configuration_methods'
require 'pagination/models/array_extension'
