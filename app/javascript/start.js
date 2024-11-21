import UniteTheArmies from "unitethearmies";

$(function () {
  let unite = new UniteTheArmies();
  unite.loadVotes();
  setInterval(function () {
    unite.loadVotes();
  }, 5000);
});
