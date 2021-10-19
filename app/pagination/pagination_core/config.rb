# frozen_string_literal: true

module Pagination
 # Configures global settings for Pagination

 class << self
   def configure
     yield config
   end

   def config
     @_config ||= Config.new
   end
 end

 class Config
   attr_accessor :default_per_page, :max_per_page, :left, :right, :page_method_name, :max_pages, :params_on_first_page
   attr_writer :param_name

   def initialize
     @default_per_page = 10
     @max_per_page = nil
     @left = 0
     @right = 0
     @page_method_name = :page
     @param_name = :page
     @max_pages = nil
     @params_on_first_page = false
   end

   # If param_name was given as a callable object, call it when returning
   def param_name
     @param_name.respond_to?(:call) ? @param_name.call : @param_name
   end
 end
end


end
