module HomeHelper
  
  def render_likes_count likes, liked, id
    if liked
      raw("<span media_id=\"#{id}\" class=\"likes my\">#{likes["count"]}</span>")
    else
      raw("<span media_id=\"#{id}\" class=\"likes not\">#{likes["count"]}</span>")
    end
  end
  
  def render_comments_count comments
    comments["count"]
  end
  
end
