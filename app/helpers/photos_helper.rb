module PhotosHelper
  
  def render_location_image x, y
    raw("<img id=\"map\" src=\"http://maps.googleapis.com/maps/api/staticmap?center=#{x},#{y}&zoom=16&size=358x150&sensor=false&markers=color:red|#{x},#{y}\">")
  end
    
end
