$(function() {
  var timer, delay = 300;
  $("#search").on('input', function () {
    var _this = $(this);
    clearTimeout(timer);
    
    timer = setTimeout(function () {
      $.ajax({
        url: "/search.json?q=" + $("#search").val(),
        success: function (r) {
          $("#results ul").empty();
          r.forEach(e => {
            if (e.type == "comment") {
              $("#results ul").append(`<li class="list-group-item list-group-item-action list-group-item-secondary"><i class="fa fa-comment-o fa-fix-width mr-2" aria-hidden="true"></i> ${e.highlight} </li>`)
            } else {
              $("#results ul").append(`<li class="list-group-item list-group-item-action list-group-item-secondary"><i class="fa fa-user-o fa-fix-width mr-2" aria-hidden="true"></i> ${e.name} </li>`)
            }
          });
        },
        error: function (e) {
          console.log(e);
        }
      });
    }, delay);
  });  
});