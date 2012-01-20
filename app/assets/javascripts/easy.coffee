# Use local alias
$ = jQuery

$(document).ready ->
  
  w = $(document).width()
  min_margin = 15
  base_w = 326 + min_margin * 2
  
  # dumb function to build dynamic grid of photos
  $(window).resize ->
    num = Math.floor($(document).width() / base_w)
    total_margin = $(document).width() - num * base_w
    margin = Math.floor(total_margin / num / 2 - 1 + min_margin)
    
    $(".photos .item").css("margin-left", margin)
    $(".photos .item").css("margin-right", margin)
  
  # trigger once to reposition pictures on load
  $(window).resize()
  
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
    if $("#feed").length
      feed = $("#feed")
      max_id = feed.attr("data-next-max-id")
      $.getJSON "/feed/next_page/#{max_id}", (data) ->
        photos_container.before(data["html"])
        $(window).resize()
        if data["next_max_id"] != ""
          feed.attr("data-next-max-id", data["next_max_id"])
          photos_container.waypoint opts
        else
          photos_container.fadeOut()
      
    if $("#user").length
      feed = $("#user")
      max_id = feed.attr("data-next-max-id")
      user_id = feed.attr("data-user-id")
      $.getJSON "/users/#{user_id}/next_page/#{max_id}", (data) ->
        photos_container.before(data["html"])
        $(window).resize()
        if data["next_max_id"] != ""
          feed.attr("data-next-max-id", data["next_max_id"])
          photos_container.waypoint opts
        else
          photos_container.fadeOut()
  
  # jquery-waypoints setup
  photos_container = $('#bottom_loader')
  opts = { 
    offset: '100%',
    triggerOnce: true,
    handler: (e, d) ->
      if d == "down"
        photos_container.waypoint "remove"
        next_page()
  }
  
  photos_container.waypoint opts