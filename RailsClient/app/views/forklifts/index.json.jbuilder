json.array!(@forklifts) do |forklift|
  json.extract! forklift, :id
  json.url forklift_url(forklift, format: :json)
end
