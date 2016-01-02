json.array!(@followings) do |following|
  json.extract! following, :id, :username, :twitter_id, :display_name, :references
  json.url following_url(following, format: :json)
end
