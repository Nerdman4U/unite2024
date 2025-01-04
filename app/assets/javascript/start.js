import UniteTheArmies from RAILS_ASSET_URL("./unitethearmies.js");

$(function () {
  let unite = new UniteTheArmies();
  window.unite = unite;
  unite.init();
  setInterval(function () {
    unite.loadVotes();
  }, 5000);
});

$(window).scroll(function () {
  let unite = window.unite;
  unite.toggleHeaderBackground();
});

$(window).resize(function () {
  let unite = window.unite;
  //unite.toggleHeaderBackground();
});
