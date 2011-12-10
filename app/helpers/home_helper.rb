module HomeHelper
  
  def render_likes_count likes, liked
    if liked
      raw "<span class=\"likes my\">#{likes["count"]}</span>"
    else
      raw "<span class=\"likes\">#{likes["count"]}</span>"
    end
  end
  
  def render_comments_count comments
    comments["count"]
  end
  
end
