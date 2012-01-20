class Meta::Image
  
  attr_reader :url, :width, :height
  
  def initialize data
    @url = data["url"]
    @width = data["width"].to_i
    @height = data["height"].to_i
  end
  
end