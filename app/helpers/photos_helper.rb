module PhotosHelper
  
  def render_location_image x, y
    raw("<a href=\"http://maps.google.com/maps?q=#{x},#{y}\" title=\"See the location on Google Maps\" target=\"_blank\"><img id=\"map\" src=\"http://maps.googleapis.com/maps/api/staticmap?center=#{x},#{y}&zoom=16&size=358x150&sensor=false&markers=color:red|#{x},#{y}\"></a>")
  end
    
end
