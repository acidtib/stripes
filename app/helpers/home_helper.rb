module HomeHelper
  
  def render_likes_count likes_count, liked, id
    if liked
      raw("<span media_id=\"#{id}\" class=\"likes my\">#{likes_count}</span>")
    else
      raw("<span media_id=\"#{id}\" class=\"likes not\">#{likes_count}</span>")
    end
  end
    
end
