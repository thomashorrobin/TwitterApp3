json.array!(@followers) do |follower|
  json.extract! follower, :id, :username, :twitter_id, :display_name, :references
  json.url follower_url(follower, format: :json)
end
