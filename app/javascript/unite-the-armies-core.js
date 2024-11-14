var site;

ready = function() {
  function loadVotes() {
    if (!recently_added_votes_path) return;
    $.get(recently_added_votes_path).success(function(data) { 
      recent_votes = new UniteTheArmies.Collections.Votes(data)
      view = new UniteTheArmies.Views.VotesIndex({collection: recent_votes})
      view.render()
      $("#recent_votes tbody").replaceWith(view.$el.html())
    })
  }
  
  function voteEvents() {
    $("a#new_vote").on("ajax:success", function(evt, data, status, xhr) {
      $("div.modal-body").html(data);
      $("form#new_vote").on("ajax:success", function(evt, data, status, xhr) {
        $("div.modal").modal("hide");
      });
      $("form#new_vote").on("ajax:error", function(evt, data, status, xhr) {});
      $("div.modal").modal("show");
    });
    $("a#new_vote").on("ajax:error", function(evt, data, status, xhr) {});
  }

  function menuEvents() {
    if ($('#pull').length < 1) return;
    var pull = $('#pull');
    menu = $('nav ul');
    menuHeight = menu.height();
    $(pull).on('click', function(e) {
      e.preventDefault();
      menu.slideToggle();
    });
    $(window).resize(function() {
      var w = $(window).width();
      if ( w > 320 && menu.is(':hidden') ) {
        menu.removeAttr('style');
      }
    });
  }

  function startShow() {
    if ($('#slider4').length < 1) return;
    $("#slider4").responsiveSlides({
      auto: true,
      pager: true,
      nav: true,
      speed: 3000,
      namespace: "callbacks",
      before: function () {
        $('.events').append("<li>before event fired.</li>");
      },
      after: function () {
        $('.events').append("<li>after event fired.</li>");
      }
    });
  }

  loadVotes();
  setInterval(function() { loadVotes() }, 5000)
  menuEvents();
  voteEvents();
  startShow();
};   

$(document).ready(ready);
$(document).on('page:load', ready);


