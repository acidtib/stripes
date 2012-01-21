# Use local alias
$ = jQuery

$(document).ready ->
  
  w = $(document).width()
  min_margin = 15
  base_w = 326 + min_margin * 2
  
  # -----
  # dumb function to build dynamic grid of photos
  $(window).resize ->
    num = Math.floor($(document).width() / base_w)
    total_margin = $(document).width() - num * base_w
    margin = Math.floor(total_margin / num / 2 - 1 + min_margin)
    
    $(".photos .item").css("margin-left", margin)
    $(".photos .item").css("margin-right", margin)
  
  # -----
  # animation triggers for Likes tab on photo page
  $("#link.likes").click ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#likes").animate {left: '0'}, "fast"
  
  $("#likes .back").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#likes").animate {left: '359'}, "fast"
  
  # animation triggers for Comments tab on photo page
  $("#link.comments").click ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#comments").animate {left: '0'}, "fast"
  
  $("#comments .back").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#comments").animate {left: '359'}, "fast"
  
  # -----
  # like/unlike toggle on photos grid page
  assign_like_clicks = () ->
    $("span.likes.not").click ->
      item = $(this)
      $.get "/photos/#{item.attr("media_id")}/like", (data) ->
        if data.meta.code == 200
          item.removeClass("not")
          item.addClass("my")
          item.html parseInt(item.html())+1
        
    $("span.likes.my").click ->
      item = $(this)
      $.get "/photos/#{item.attr("media_id")}/unlike", (data) ->
        if data.meta.code == 200
          item.addClass("not")
          item.removeClass("my")
          item.html parseInt(item.html())-1
  
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
      $(window).resize()
      
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
  $(window).resize()