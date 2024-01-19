# https://dev.37signals.com/active-record-nice-and-blended/
# https://dev.37signals.com/active-record-nice-and-blended/
# https://dev.37signals.com/active-record-nice-and-blended/


# @events = Timeline::Aggregator.new(Current.person, filter: current_page_by_creator_filter).events

# class Timeline::Aggregator
#   def initialize(person, filter: nil)
#     @person = person
#     @filter = filter
#   end
# end


# @events = Timeline::Aggregator.new(Current.person, filter: current_page_by_creator_filter).events


class OrderContent::Aggregator
  attr_reader :order_content, :packaging_materials

  def initialize(order_content, filter: nil)
    @order_content = order_content
    @packaging_materials = order_content.packaging_materials
    @filter = filter
  end

  def filter
    @filter
  end

  def filter=(filter)
    @filter = filter
  end

  def packaging_material_ids
    packaging_materials.ids
  end

  def filter
    return nil unless format_filter
    return send @filter.to_sym if @filter.to_sym.in? methods
    return send @filter.to_s.pluralize.to_sym if @filter.to_s.pluralize.to_sym.in? methods
    return send @filter.to_s.singularize.to_sym if @filter.to_s.singularize.to_sym.in? methods
  end

  def format_filter
    return false unless @filter

    return true if @filter.to_sym.in? methods
    return true if @filter.to_s.pluralize.to_sym.in? methods
    return true if @filter.to_s.singularize.to_sym.in? methods

    return false
  end

  def where_not_description_blank
    return nil unless format_filter
    filter.where.not(description: [nil, ''])
  end

  def where_description_blank
    return nil unless format_filter
    filter.where(description: [nil, ''])
  end

  def where_descriptions_match(description: nil)
    return nil unless format_filter
    return nil unless where_not_description_blank.exists?

    # grouped_packaging_materials_with_descriptions = where_not_description_blank.select("description").group("description") # NOTE - ONLY GETS DESCRIPTIONS (+ AUTO INCLUDED TYPE)
    return where_not_description_blank.where('lower(description) = ?', description.downcase) unless description.nil?
  end

  def boxes
    order_content.packaging_materials_boxes
  end

  def pallets
    order_content.packaging_materials_pallets
  end

  def crates
    order_content.packaging_materials_crates
  end

  def others
    order_content.packaging_materials_others
  end

  # def ids
  #   filter
  # end

  # private
  #   def event_ids
  #     event_ids_via_optimized_query(1.week.ago) || event_ids_via_optimized_query(3.months.ago) || event_ids_via_regular_query
  #   end
  #
  #   # Fetching the most recent recordings optimizes the query enormously for large sets of recordings
  #   def event_ids_via_optimized_query(created_since)
  #     limit = extract_limit
  #     event_ids = filtered_ordered_recordings.where("recordings.created_at >= ?", created_since).pluck("relays.event_id")
  #     event_ids if event_ids.length >= limit
  #   end
  #
  #   def event_ids_via_regular_query
  #     filtered_ordered_recordings.pluck("relays.event_id")
  #   end
end
