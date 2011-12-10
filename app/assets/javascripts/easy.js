$(document).ready(function() {
  var w = $(document).width();
  var min_margin = 15;
  var base_w = 326 + min_margin * 2;
  
  $(window).resize(function() {
    var num = Math.floor($(document).width() / base_w);
    var total_margin = $(document).width() - num * base_w;
    var margin = Math.floor(total_margin / num / 2 - 1 + min_margin);
    
  //  console.log("Num = " + num + ", Margin = " + margin + ", Total W = " + $(document).width());
    
    $(".photos .item").css("margin-left", margin);
    $(".photos .item").css("margin-right", margin);
  });
  
  $(window).resize();
  
  // -----
  
  $("#link.likes").click(function(){
    $("#general").animate({left: '-=358'}, "fast");
    $("#likes").animate({left: '0'}, "fast");
  });
  
  $("#likes .back").click(function(){
    $("#general").animate({left: '0'}, "fast");
    $("#likes").animate({left: '359'}, "fast");
  });
  
  $("#link.comments").click(function(){
    $("#general").animate({left: '-=358'}, "fast");
    $("#comments").animate({left: '0'}, "fast");
  });
  
  $("#comments .back").click(function(){
    $("#general").animate({left: '0'}, "fast");
    $("#comments").animate({left: '359'}, "fast");
  });
});