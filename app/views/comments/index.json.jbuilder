json.array!(@comments) do |comment|
  json.extract! comment, :id, :topic, :body, :email, :language, :name
  json.url comment_url(comment, format: :json)
end
