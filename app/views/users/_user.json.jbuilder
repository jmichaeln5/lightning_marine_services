json.extract! user, :id, :first_name, :last_name, :phone_number, :email, :username, :created_at, :updated_at
json.url user_url(user, format: :json)

# json.user_friend_request = user.friend_requests_as_receiver.where(requestor_id: current_user.id).first
