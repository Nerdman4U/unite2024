class UniteTheArmies {
  constructor() {}
  loadVotes() {
    if (!recently_added_votes_path) return;
    if (unite_state !== "ready") return;
    fetch(recently_added_votes_path)
      .then((response) => response.json())
      .then((data) => {
        let result = "";
        data.forEach(function (vote) {
          let tmpl_row = `<tr>
            <td><image class="flag_small ${vote.country}"/></td>
            <td>${vote.name}</td>
          </tr>`;
          result += tmpl_row;
        });
        $("#recent_votes tbody").replaceWith(result);
      });
  }

  voteEvents() {
    $("a#new_vote").on("ajax:success", function (evt, data, status, xhr) {
      $("div.modal-body").html(data);
      $("form#new_vote").on("ajax:success", function (evt, data, status, xhr) {
        $("div.modal").modal("hide");
      });
      $("form#new_vote").on("ajax:error", function (evt, data, status, xhr) {});
      $("div.modal").modal("show");
    });
    $("a#new_vote").on("ajax:error", function (evt, data, status, xhr) {});
  }

  menuEvents() {
    if ($("#pull").length < 1) return;
    var pull = $("#pull");
    menu = $("nav ul");
    menuHeight = menu.height();
    $(pull).on("click", function (e) {
      e.preventDefault();
      menu.slideToggle();
    });
    $(window).resize(function () {
      var w = $(window).width();
      if (w > 320 && menu.is(":hidden")) {
        menu.removeAttr("style");
      }
    });
  }

  startShow() {
    if ($("#slider4").length < 1) return;
    $("#slider4").responsiveSlides({
      auto: true,
      pager: true,
      nav: true,
      speed: 3000,
      namespace: "callbacks",
      before: function () {
        $(".events").append("<li>before event fired.</li>");
      },
      after: function () {
        $(".events").append("<li>after event fired.</li>");
      },
    });
  }
}

// loadVotes();
// setInterval(function () {
// loadVotes();
// }, 5000);
//menuEvents();
//voteEvents();
//startShow();

// $(document).ready(ready);
// $(document).on("page:load", ready);

export default UniteTheArmies;
