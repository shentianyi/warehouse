json.array!(@fortlifts) do |fortlift|
  json.extract! fortlift, :id
  json.url fortlift_url(fortlift, format: :json)
end
