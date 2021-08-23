json.extract! order, :id, :created_at, :updated_at, :purchaser, :vendor
json.url order_url(order, format: :json)
