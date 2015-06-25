$(document).ready(function() {

  // Abort if jQuery is broken (happens when annotorious library is loaded on photos page)
  if ($("#render-relations-toggle") == null) {
    return;
  }

  $("#render-relations-toggle").click(function(){
    if ($("#render-relations-toggle").attr("done") == "true") {
      return;
    }
    $("#render-relations").show();
    var svg = $("#viz-container");//.html();
    
    svg.find("defs").prepend('<style type="text/css"><![CDATA[ path.link { marker-end: none; fill: none; stroke: #999; stroke-width: 2px; } ]]></style>');
    var pos = $("<div class='alert alert-info'>").text("Generowanie...");
    $("#render-relations").append(pos);
    $.post("/svg_renders",
      {svg: svg.html()},
      function(data){
        var content;
        if(data['url']){
          content = "<a href='" + data.url + "'>" + data.url + "</a>";
        }else{
          if(data['errors']){
            content = data.errors;
          }else{
            content = "Wystąpił błąd podczas generowania obrazu jpg";
          }
        }
        pos.html(content);
        $("#render-relations-toggle").attr("done", "true");
      },
      'json');
  });
});
