# Use local alias
$ = jQuery

$(document).ready ->

  w = $(document).width()
  min_margin = 15
  base_w = 326 + min_margin * 2

  # -----
  # animation triggers for Likes tab on photo page
  likes_link = $("#pages #likes-link")

  likes_link.on "click", ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#likes").animate {left: '0'}, "fast"

  $("#likes .navbar span").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#likes").animate {left: '359'}, "fast"

  # -----
  # on-demand loading for too much likes
  likes_preloader = $("#photo #likes #likes_placeholder")
  if likes_preloader.length > 0

    preload_likes = () ->
      console.log "THING"
      photo = $("#photo")

      $.getJSON "/photos/#{photo.attr("data-media-id")}/load/likes", (data) ->
        likes_container = likes_preloader.parent()
        likes_container.empty()
        console.log data
        likes_container.html(data.html)
        likes_link.off "click", preload_likes

    likes_link.on "click", preload_likes

  # -----
  # animation triggers for Comments tab on photo page
  comments_link = $("#pages #comments-link")

  comments_link.on "click", ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#comments").animate {left: '0'}, "fast"

  $("#comments .navbar span").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#comments").animate {left: '359'}, "fast"

  # -----
  # on-demand loading for too much comments
  comments_preloader = $("#photo #comments #comments_placeholder")
  if comments_preloader.length > 0
    preload_comments = () ->
      photo = $("#photo")

      $.getJSON "/photos/#{photo.attr("data-media-id")}/load/comments", (data) ->
        comments_container = comments_preloader.parent()
        comments_container.empty()
        comments_container.html(data.html)
        comments_link.off "click", preload_comments

    comments_link.on "click", preload_comments

  # -----
  # like/unlike toggle on photos grid page
  toggle_like_media = (photos_item) ->
    number_object = photos_item.children().last()

    if photos_item.hasClass "liked"
      $.get "/photos/#{photos_item.attr("data-media-id")}/unlike", (data) ->
        if data.ok
          photos_item.removeClass("liked")
          number_object.html parseInt(number_object.html())-1
        else
          alert data.message
    else
      $.get "/photos/#{photos_item.attr("data-media-id")}/like", (data) ->
        if data.ok
          photos_item.addClass("liked")
          number_object.html parseInt(number_object.html())+1
        else
          alert data.message

  assign_like_clicks = () ->
    $("li.like").off "click"
    $("li.like").on "click", () ->
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
      fake_preloader.before(data.html)
      assign_like_clicks()

      if data["next_max_id"]
        feed.attr("data-next-max-id", data.next_max_id)
        $(window).on "scroll", if_reached_bottom
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
      $(window).off "scroll"

  $(window).on "scroll", if_reached_bottom
  $(window).trigger "scroll"
  assign_like_clicks()

  # -----
  # follow user
  user_follow_button = $("#userinfo #button-follow")
  user_unfollow_button = $("#userinfo #button-unfollow")

  follow_and_transform_button = () ->
    user_follow_button.addClass "down"
    user_follow_button.html ""

    $.getJSON "/users/#{$("#user").attr("data-user-id")}/follow", (data) ->
      if data.ok
        user_follow_button.animate {width: 35, paddingLeft: 0, paddingRight: 0}, 250, "swing", () ->
          user_follow_button.html ""
          user_follow_button.removeClass "down"
          user_follow_button.addClass "following flat"
          user_follow_button.bind "click", unfollow_and_transform_button
          user_follow_button.unbind "click", follow_and_transform_button
          user_unfollow_button = user_follow_button
          $("#meta-followers").html data.html
      else
        user_follow_button.removeClass "down"
        user_follow_button.html "Follow"
        alert data.message

  unfollow_and_transform_button = () ->
    user_unfollow_button.addClass "down"

    $.getJSON "/users/#{$("#user").attr("data-user-id")}/unfollow", (data) ->
      if data.ok
        user_unfollow_button.html "Follow"
        user_unfollow_button.removeClass "down following flat"
        user_unfollow_button.addClass "follow"
        user_unfollow_button.unbind "click", unfollow_and_transform_button
        user_unfollow_button.animate {width: 45, paddingLeft: 35, paddingRight: 15}
        user_follow_button = user_unfollow_button
        user_follow_button.bind "click", follow_and_transform_button
        $("#meta-followers").html data.html
      else
        user_unfollow_button.removeClass "down"
        alert data.message

  user_follow_button.bind "click", follow_and_transform_button
  user_unfollow_button.bind "click", unfollow_and_transform_button

  #-------------------------------

  # abstract action button constructor and handler
  action_button = (action_id, toggle_action_name, untoggle_action_name, toggle_action_url, untoggle_action_url, toggle_action_handler = null, untoggle_action_handler = null, id_to_update = null) ->

    button = $("#action-#{action_id}")

    button.on "click", () ->
      t = not button.hasClass "toggled"
      button.addClass("down").html("")

      $.getJSON (if t then toggle_action_url else untoggle_action_url), (data) ->

        if null != (if t then toggle_action_handler else untoggle_action_handler)
          if t then toggle_action_handler(button, data) else untoggle_action_handler(button, data)
        else
          button.removeClass "down"
          if data.ok
            if t then button.addClass("toggled") else button.removeClass("toggled")
            button.html(if t then untoggle_action_name else toggle_action_name)
            $("##{id_to_update}").html data.html if id_to_update

  media_id = $("#photo").attr "data-media-id"
  action_button("like", "", "", "/photos/#{media_id}/like", "/photos/#{media_id}/unlike", null, null, "likes-link")

  # -----
  # commenting function
  comment_form = $("#comments-form textarea")
  comment_form_button = $("#action-post-comment")
  comment_load_image = $("#comment-preloader")

  comment_form_button.click ->
    comment_text = comment_form.val()

    unless comment_text == ''
      comment_form.addClass("disabled")
      comment_form.attr("disabled", "disabled")
      comment_load_image.toggleClass("hidden")
      char_counter_holder.toggleClass("hidden")

      $.post "/photos/#{$("#photo").attr("data-media-id")}/comment", { "text" : comment_text }, (data) ->

        if data.ok
          $("#comments ul").append data.html
          comment_form.val ""
          char_counter.text "0"
          $("#comments .navbar").html data.counter_update
        else
          alert data.message

        comment_form.removeClass("disabled")
        comment_form.removeAttr("disabled")
        comment_load_image.toggleClass("hidden")
        char_counter_holder.toggleClass("hidden")

    else
      alert "You need to type in the comment first!"

  char_counter = $("#characters-counter")
  char_counter_holder = $("#comments-form span.counter")
  comment_form.keyup ->
    char_counter.text comment_form.val().length
    if comment_form.val().length == 200
      char_counter_holder.addClass "full"
    else
      char_counter_holder.removeClass "full" if char_counter_holder.hasClass "full"