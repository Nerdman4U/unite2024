import UniteTheArmies from "unitethearmies";

$(function () {
  let unite = new UniteTheArmies();
  unite.loadVotes();
  window.unite = unite;
  setInterval(function () {
    unite.loadVotes();
  }, 5000);
});
