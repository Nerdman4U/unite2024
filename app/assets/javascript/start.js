import UniteTheArmies from RAILS_ASSET_URL("./unitethearmies.js");

$(function () {
  window.funks = $([])
  let unite = new UniteTheArmies();
  unite.load();
  unite.init();
  window.unite = unite;
  window.funks.push([unite.loadVotes, unite])
  setInterval(function () {
    for (let items of funks) {
      items[0].call(items[1])
    }
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
