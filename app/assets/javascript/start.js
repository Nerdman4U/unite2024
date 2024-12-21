import UniteTheArmies from RAILS_ASSET_URL("./unitethearmies.js");

$(function () {
  let unite = new UniteTheArmies();
  window.unite = unite;

  unite.loadVotes();
  setInterval(function () {
    unite.loadVotes();
  }, 5000);
});
