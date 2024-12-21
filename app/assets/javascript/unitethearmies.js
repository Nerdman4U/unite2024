class UniteTheArmies {
  constructor() {}
  closeFlash() {
    $(".alert").hide();
  }
  loadVotes() {
    if (RUN_RECENT_VOTES === 0) return;
    fetch("/votes/recently_added.json")
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

export default UniteTheArmies;
