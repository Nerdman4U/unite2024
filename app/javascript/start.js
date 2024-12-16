import UniteTheArmies from "unitethearmies";

$(function () {
  let unite = new UniteTheArmies();
  window.unite = unite;

  unite.loadVotes();
  setInterval(function () {
    unite.loadVotes();
  }, 5000);
});
