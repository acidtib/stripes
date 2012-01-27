# Use local alias
$ = jQuery

$(document).ready ->
  
  w = $(document).width()
  min_margin = 15
  base_w = 326 + min_margin * 2
  
  # -----
  # animation triggers for Likes tab on photo page
  $("#actions #likes-link").bind "click", () ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#likes").animate {left: '0'}, "fast"
  
  $("#likes #navbar span").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#likes").animate {left: '359'}, "fast"
  
  # animation triggers for Comments tab on photo page
  $("#actions #comments-link").bind "click", () ->
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

    if feed.attr("data-next-max-id") == ''
      fake_preloader.html("<p>The end!</p>")
      return false

    $.getJSON url, (data) ->
      fake_preloader.before(data["html"])
      assign_like_clicks()
      
      if data["next_max_id"] != ""
        feed.attr("data-next-max-id", data["next_max_id"])
        $(window).bind "scroll", if_reached_bottom
      else
        feed.removeAttr("data-next-max-id")
        fake_preloader.html("<p>The end!</p>")
  
  # -----
  # infinite scroll
  fake_preloader = $('#fake-preloader')

  if_reached_bottom = () ->
    bottom_offset = 400
    scroll_top = $(document).scrollTop()  
    scroll_height = $(window).height()
    body_height = $(document).height()
    
    if (scroll_height + scroll_top) >= (body_height - bottom_offset)
      next_page()
      $(window).unbind()

  $(window).bind "scroll", if_reached_bottom
  $(window).trigger "scroll"
  assign_like_clicks()

  # -----
  # on-demand loading for too much likes
  likes_preloader = $("#photo #likes #likes_placeholder")
  if likes_preloader.length > 0
    likes_link = $("#actions #likes-link")

    preload_likes = () ->
      photo = $("#photo")

      $.getJSON "/photos/#{photo.attr("data-media-id")}/load/likes", (data) ->
        likes_container = likes_preloader.parent()
        likes_container.empty()
        likes_container.html(data["html"])
        likes_link.unbind "click", preload_likes

    likes_link.bind "click", preload_likes

  # -----
  # on-demand loading for too much comments
  comments_preloader = $("#photo #comments #comments_placeholder")
  if comments_preloader.length > 0
    comments_link = $("#actions #comments-link")

    preload_comments = () ->
      photo = $("#photo")

      $.getJSON "/photos/#{photo.attr("data-media-id")}/load/comments", (data) ->
        comments_container = comments_preloader.parent()
        comments_container.empty()
        comments_container.html(data["html"])
        comments_link.unbind "click", preload_comments

    comments_link.bind "click", preload_comments
      