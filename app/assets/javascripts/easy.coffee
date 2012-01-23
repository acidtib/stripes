# Use local alias
$ = jQuery

$(document).ready ->
  
  w = $(document).width()
  min_margin = 15
  base_w = 326 + min_margin * 2
  
  # -----
  # animation triggers for Likes tab on photo page
  $("#actions .likes").click ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#likes").animate {left: '0'}, "fast"
  
  $("#likes #navbar span").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#likes").animate {left: '359'}, "fast"
  
  # animation triggers for Comments tab on photo page
  $("#actions .comments").click ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#comments").animate {left: '0'}, "fast"
  
  $("#comments #navbar span").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#comments").animate {left: '359'}, "fast"

  # -----
  # like/unlike toggle on photos grid page
  toggle_like_media = (photos_item) ->
    number_object = photos_item.children().last()
    
    if photos_item.hasClass "liked"
      $.get "/photos/#{photos_item.attr("data-media-id")}/unlike", (data) ->
        if data.meta.code == 200
          photos_item.removeClass("liked")
          number_object.html parseInt(number_object.html())-1
    else
      $.get "/photos/#{photos_item.attr("data-media-id")}/like", (data) ->
        if data.meta.code == 200
          photos_item.addClass("liked")
          number_object.html parseInt(number_object.html())+1

  assign_like_clicks = () ->
    $("li.like").unbind()
    $("li.like").click -> 
      toggle_like_media $(this)
    
  # -----
  # infinite scrolling implementation
  next_page = () ->
    url = 0
    feed = 0
    
    if $("#feed").length
      feed = $("#feed")
      url = "/feed/next_page/#{feed.attr("data-next-max-id")}"
    else if $("#user").length
      feed = $("#user")
      url = "/users/#{feed.attr("data-user-id")}/next_page/#{feed.attr("data-next-max-id")}"
    else
      return false
      
    $.getJSON url, (data) ->
      fake_preloader.before(data["html"])
      assign_like_clicks()
      
      if data["next_max_id"] != ""
        feed.attr("data-next-max-id", data["next_max_id"])
        fake_preloader.waypoint opts
      else
        feed.removeAttr("data-next-max-id")
        fake_preloader.html("<p>The end!</p>")
  
  # -----
  # setup for waypoints and initial function calls
  fake_preloader = $('#fake-preloader')
  opts = { 
    offset: '100%',
    triggerOnce: true,
    handler: (e, d) ->
      if d == "down"
        fake_preloader.waypoint "remove"
        next_page()
  }
  
  fake_preloader.waypoint opts
  assign_like_clicks()