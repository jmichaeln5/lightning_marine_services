module Searchable
  extend ActiveSupport::Concern

  included do
    searchkick
  end

  def exactly_matches_with?(query_str)
    return false if query_str.nil? or query_str.blank?
    return search_data.compact.values.include? query_str
  end

  def matches_with?(query_str)
    return false if query_str.nil? or query_str.blank?

    collated_query_str = query_str.clone.downcase.delete(" ")
    collated_search_data = search_data.values.clone.compact_blank

    collated_search_data_arr = Array.new
    collated_search_data.each do |d|
      collated_search_data_arr.push d.downcase if d.respond_to? :downcase
    end

    return collated_query_str.in? collated_search_data_arr
  end

  def find_humanized_keys_from_value(val)
    search_data_arr = search_data.to_a

    matching_key = nil
    search_data_arr.map {|d| (matching_key = d[0]) if (d[1].to_s.downcase == val.strip.downcase) }
    humanized_key = self.class.human_attribute_name(matching_key.to_s.downcase) if matching_key
    humanized_key ||= matching_key
    return humanized_key
  end
end
