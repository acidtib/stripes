class Meta::ImageData
  
  attr_reader :small, :medium, :large
  
  def initialize data
    @small = Meta::Image.new data["thumbnail"]
    @medium = Meta::Image.new data["low_resolution"]
    @large = Meta::Image.new data["standard_resolution"]
  end
  
end