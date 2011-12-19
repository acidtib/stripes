# Use local alias
$ = jQuery

$(document).ready ->
  
  w = $(document).width()
  min_margin = 15
  base_w = 326 + min_margin * 2
  
  $(window).resize ->
    num = Math.floor($(document).width() / base_w)
    total_margin = $(document).width() - num * base_w
    margin = Math.floor(total_margin / num / 2 - 1 + min_margin)
    
    $(".photos .item").css("margin-left", margin)
    $(".photos .item").css("margin-right", margin)
  
  $(window).resize()
  
  # -----
  
  $("#link.likes").click ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#likes").animate {left: '0'}, "fast"
  
  $("#likes .back").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#likes").animate {left: '359'}, "fast"
  
  $("#link.comments").click ->
    $("#general").animate {left: '-=358'}, "fast"
    $("#comments").animate {left: '0'}, "fast"
  
  $("#comments .back").click ->
    $("#general").animate {left: '0'}, "fast"
    $("#comments").animate {left: '359'}, "fast"
    
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
    