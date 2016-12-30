json.array!(@dock_points) do |dock_point|
  json.extract! dock_point, :id, :nr, :desc
  json.url dock_point_url(dock_point, format: :json)
end
