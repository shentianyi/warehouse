class LocationService
  def self.search params
    Location.where(params).first
  end
end