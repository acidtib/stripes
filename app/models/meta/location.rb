class Meta::Location
  
  attr_reader :latitude, :longitude
  
  def initialize(lat = nil, long = nil)
    @latitude = lat
    @longitude = long
  end
  
end