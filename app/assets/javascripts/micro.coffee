# Welcome to the adventures of micro frameworks in the world of Watermelon!
# Used frameworks: bean, bonzo, domready, morpheus, qwery, reqwest
# by Dustin Diaz: http://github.com/ded

domReady ->
  # things for infinite scroll
  bottom_offset = 400
  window_scroll_top = () ->
    objectize(select_first("html")).scrollTop()

  # straight object retreiver
  element_with_id = (id) ->
    item = document.getElementById id
    if item then item else false

  # selector for complicated situations
  select = (selector) ->
    items = qwery selector
    if items.length then items else false

  select_first = (selector) ->
    items = qwery selector
    if items.length then items[0] else false

  first_parent_of_element = (element) ->
    objectize(element).parent()[0]

  # in case we need some manipulation and stuff, let's use bonzo
  objectize = (element) ->
    bonzo element

  # wrapper for GET
  xhr_get = (url, callback) ->
    reqwest
      url: url,
      type: 'json',
      method: 'get',
      success: callback

  # wrapper for POST, supports Rails
  xhr_post = (url, params_map, callback) ->
    reqwest
      url: url,
      type: 'json',
      method: 'post',
      headers: {
        "X-CSRF-Token": objectize(select_first("meta[name=csrf-token]")).attr("content")
      },
      data: params_map,
      success: callback

  # somewhat complicated life bringer to action buttons
  two_state_json_action_button = (action_id, names = {}, urls = {}, handlers = {}, elements_to_update = [], clear_on_click = true) ->
    button_element = element_with_id action_id
    button = objectize button_element

    bean.add button_element, "click", () ->
      next_action = if button.hasClass "toggled" then "untoggle" else "toggle"
      current_action = if button.hasClass "toggled" then "toggle" else "untoggle"

      button.addClass "down"
      button.html "" if clear_on_click

      xhr_get urls[next_action], (data) ->
        button.removeClass "down"
        if handlers[next_action] # calling custom handlers if any
          handlers[next_action](button_element, data, names, elements_to_update, next_action, current_action)
        else
          if data.ok
            button.toggleClass("toggled").html(names[current_action])
            objectize(element_with_id(replace.what)).html(data[replace.with]) for replace in elements_to_update
          else
            alert data.message

  # ------------------------------------------------------------------------------------------

  user_profile = element_with_id("userinfo")
  feed_page = element_with_id("feed")
  photo = element_with_id("photo")

  # ------------------------------------------------------------------------------------------

  # if we're on the single photo page
  if photo
    instagram_id = objectize(photo).attr "data-media-id"

    preload_likes_text = element_with_id "likes-placeholder"
    photo_likes =
      placeholder:  preload_likes_text
      link:         element_with_id "likes-link"
      container:    if preload_likes_text then first_parent_of_element(preload_likes_text) else false
      link_to_back: select_first "#likes .navbar span"

    preload_comments_text = element_with_id "comments-placeholder"
    photo_comments =
      placeholder:  preload_comments_text
      link:         element_with_id "comments-link"
      container:    select_first "#comments ul"
      link_to_back: select_first "#comments .navbar span"

    comments_form =
      textarea: objectize select_first("#comments-form textarea")
      submit:   element_with_id "action-post-comment"
      spinner:  objectize element_with_id("comment-preloader")
      counter:  objectize element_with_id("characters-counter")
      counter_container: objectize select_first("#comments-form span.counter")

    pages =
      likes:    element_with_id "likes"
      comments: element_with_id "comments"
      info:     element_with_id "general"

    disable_comments_form = () ->
      comments_form.textarea.addClass("disabled").attr("disabled", "yes")
      comments_form.spinner.removeClass("hidden")
      comments_form.counter_container.addClass("hidden")

    enable_comments_form = () ->
      comments_form.textarea.removeClass("disabled").removeAttr("disabled")
      comments_form.spinner.addClass("hidden")
      comments_form.counter_container.removeClass("hidden")

    post_comment = () ->
      text = comments_form.textarea.val()
      unless text == ''
        disable_comments_form()

        xhr_post "/photos/#{instagram_id}/comment", { text: text }, (data) ->
          if data.ok
            objectize(photo_comments.container).append data.html
            comments_form.textarea.val ""
            comments_form.counter.text "0"
          else
            alert data.message

          enable_comments_form()
      else
        alert "You'd better type a comment first!"

    current_page = "info"

    slide_to_likes = () ->
      morpheus pages.info,  { left: -360, duration: 250, easing: null }
      morpheus pages.likes, { left: 0,    duration: 250, easing: null }
      current_page = "likes"

    slide_to_comments = () ->
      morpheus pages.info,     { left: -360, duration: 250, easing: null }
      morpheus pages.comments, { left: 0,    duration: 250, easing: null }
      current_page = "comments"

    slide_to_info = () ->
      if current_page == "likes"
      then morpheus pages.likes,    { left: 360,  duration: 250, easing: null }
      else morpheus pages.comments, { left: 360,  duration: 250, easing: null }
      morpheus pages.info, { left: 0, duration: 250, easing: null }
      current_page == "info"

    load_likes = () ->
      xhr_get "/photos/#{instagram_id}/load/likes", (data) ->
        objectize(photo_likes.container).empty().html(data.html)

    load_comments = () ->
      xhr_get "/photos/#{instagram_id}/load/comments", (data) ->
        objectize(photo_comments.container).empty().html(data.html)

    count_comment_characters = () ->
      size = comments_form.textarea.val().length
      comments_form.counter.text size
      if size >= 200
      then comments_form.counter_container.addClass "full"
      else comments_form.counter_container.removeClass "full"

    bean.add comments_form.submit,     "click", post_comment
    bean.add photo_likes.link,         "click", slide_to_likes
    bean.add photo_likes.link_to_back, "click", slide_to_info
    bean.add photo_comments.link,         "click", slide_to_comments
    bean.add photo_comments.link_to_back, "click", slide_to_info
    bean.add select_first("#comments-form textarea"), "keyup", count_comment_characters

    bean.one photo_likes.link,    "click", load_likes if photo_likes.placeholder
    bean.one photo_comments.link, "click", load_comments if photo_comments.placeholder

    two_state_json_action_button "action-like",
      null,
      { toggle: "/photos/#{instagram_id}/like", untoggle: "/photos/#{instagram_id}/unlike" },
      null,
      [{ what: "likes-link", with: "html" }],
      true

  # ------------------------------------------------------------------------------------------

  # if we're on the user profile page
  if user_profile
    user_id = objectize(user_profile).attr "data-user-id"

    follow_button_following = (button, data, names, elements_to_update, next_action, current_action) ->
      button_object = objectize button

      if data.ok
        button_object.toggleClass("toggled").html(names[current_action])
        morpheus button, {
          width: 35, paddingLeft: 0, paddingRight: 0,
          duration: 350, easing: null
        }

        objectize(element_with_id(replace.what)).html(data[replace.with]) for replace in elements_to_update
      else
        button_object.html names[next_action]
        alert data.message

    follow_button_not_following = (button, data, names, elements_to_update, next_action, current_action) ->
      button_object = objectize button

      if data.ok
        button_object.toggleClass("toggled")
        morpheus button, {
          width: 45, paddingLeft: 40, paddingRight: 15,
          duration: 350, easing: null,
          complete: ->
            button_object.html(names[current_action])
        }

        objectize(element_with_id(replace.what)).html(data[replace.with]) for replace in elements_to_update
      else
        button_object.html names[next_action]
        alert data.message

    # making Follow button usable
    two_state_json_action_button "action-follow",
      { toggle: "Follow", untoggle: "" }, # "" is "unfollow", but empty, because of the icon
      { toggle: "/users/#{user_id}/follow", untoggle: "/users/#{user_id}/unfollow" },
      { toggle: follow_button_following, untoggle: follow_button_not_following },
      [{ what: "meta-followers", with: "html"}],
      true

  # ------------------------------------------------------------------------------------------

  # if got to feed page and we got preloader, meaning we have something to load indeed
  # and it's not just a static page like /popular
  if feed_preloader = element_with_id "fake-preloader"
    # and we already have user_id from the section above if anything
    feed_preloader_object = objectize feed_preloader
    feed_page_object = objectize feed_page

    if_reached_bottom = () ->
      scroll_top = window_scroll_top()
      window_height = bonzo.viewport().height
      html_height = bonzo.doc().height

      if (window_height + scroll_top) >= (html_height - bottom_offset)
        bean.remove window, "scroll"
        next_feed_page()

    bind_like_clicks = ()->
      like_links = select "li.like"
      bean.remove link for link in like_links
      bean.add link, "click", toggle_like_media for link in like_links

    toggle_like_media = (event) ->
      like_link = objectize event.currentTarget
      media_id = like_link.attr("data-media-id")
      action = if like_link.hasClass("liked") then "unlike" else "like"
      xhr_get "/photos/#{media_id}/#{action}", (data) ->
        if data.ok
          like_link.toggleClass "liked"
          like_link.html "<span>Likes:</span> <b>#{data.count}</b>"
        else
          alert data.message

    next_feed_page = () ->
      if next_max_id = objectize(feed_page).attr("data-next-max-id")
        console.log "HEJSAN"
        next_page_url = if user_profile then "/users/#{user_id}/next_page/#{next_max_id}" else "/feed/next_page/#{next_max_id}"

        xhr_get next_page_url, (data) ->
          feed_preloader_object.before data.html
          if data.next_max_id
            feed_page_object.attr "data-next-max-id", data.next_max_id
            bean.add window, "scroll", if_reached_bottom
            bind_like_clicks()
          else
            feed_page_object.removeAttr "data-next-max-id"
            feed_preloader_object.html "No more photos for now."
      else
        objectize(feed_preloader).html "The end!"
        false

    bean.add window, "scroll", if_reached_bottom
    bind_like_clicks()