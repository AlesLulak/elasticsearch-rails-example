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
            $("#results ul").append(`<li class="list-group-item list-group-item-action list-group-item-secondary"> ${e.firstname} ${e.lastname} </li>`)
          });
        },
        error: function (e) {
          console.log(e);
        }
      });
    }, delay);
    
  });
});