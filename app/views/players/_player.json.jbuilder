json.extract! player, :id, :name, :phone_number, :terms_and_conditions_accepted, :created_at, :updated_at
json.url player_url(player, format: :json)
