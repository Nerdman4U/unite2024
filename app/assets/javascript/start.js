import UniteTheArmies from RAILS_ASSET_URL("./unitethearmies.js");

$(function () {
  let unite = new UniteTheArmies();
  unite.load();
  unite.init();
  window.unite = unite;
  window.funks = [unite.loadVotes]
  setInterval(function () {
    // for (let f of funks) {
    //   f().bind(unite)
    // }
    unite.loadVotes()
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
