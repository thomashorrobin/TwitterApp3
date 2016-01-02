json.array!(@accounts) do |account|
  json.extract! account, :id, :username, :twitter_id, :display_name
  json.url account_url(account, format: :json)
end
