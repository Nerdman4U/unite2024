import UniteTheArmies from RAILS_ASSET_URL("./unitethearmies.js");

class Interval {
  constructor() {
    this.intervals = {}
  }
  create(interval, callback) {
    return setInterval(callback, interval);
  }
  register(interval, callback) {
    // console.log('Interval#register() %s', interval)
    if (this.intervals[interval]) {
      return;
    }
    this.intervals[interval] = this.create(interval, callback)
  }
  remove(interval) {
    // console.log('Interval#remove() %s', interval);
    if (!this.intervals[interval]) {
      // console.log('not removed')
      return
    }
    clearInterval(this.intervals[interval]);
  }
}

let timers = new Interval();
window.timers = timers;

$(function () {
  window.funks = $([])
  let unite = new UniteTheArmies();
  unite.load();
  unite.init();
  window.unite = unite;
  window.funks.push([unite.loadVotes, unite])
  window.timers.register(5000, function() { unite.loadVotes() })
});

$(window).scroll(function () {
  let unite = window.unite;
  unite.toggleHeaderBackground();
});

$(window).resize(function () {
  let unite = window.unite;
  //unite.toggleHeaderBackground();
});
