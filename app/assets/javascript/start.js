import UniteTheArmies from RAILS_ASSET_URL("./unitethearmies.js");

class Interval {
  constructor() {
    this.intervals = {}
  }
  create(interval, callback) {
    return setInterval(callback, interval);
  }

  /**
   *
   * @param {integer} interval in millisecods
   * @param {function} callback
   * @returns integer
   */
  register(interval, callback) {
    // console.log('Interval#register() %s', interval)
    if (this.intervals[interval]) {
      // console.error('Interval#register() %s already registered', interval)
      return;
    }
    let int = this.create(interval, callback);
    this.intervals[interval] = int;
    return int;
  }
  /**
   * Returns result of clearInterval().
   */
  unregister(interval) {
    console.log('Interval#unregister() %s', interval);
    if (!this.intervals[interval]) {
      // console.log('not removed')
      return
    }
    clearInterval(this.intervals[interval]);
    return delete this.intervals[interval];
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
  window.timers.register(60000, function() { unite.loadVotes() })
});

$(window).scroll(function () {
  let unite = window.unite;
  unite.toggleHeaderBackground();
});

$(window).resize(function () {
  let unite = window.unite;
  //unite.toggleHeaderBackground();
});
