class RecentVotes {
  constructor() {}

  doLoad() {
    return !!RUN_RECENT_VOTES;
  }

  init() {
    if (!this.doLoad()) return;
    this.loadVotes();
  }

  loadVotes() {
    if (!this.doLoad()) {
      return;
    }
    fetch("/votes/recently_added.json")
      .then((response) => response.json())
      .then((data) => {
        let result = "";
        data.forEach(function (vote) {
          let tmpl_row = `<div class="row">
            <div class="col-2"><image class="flag_small ${vote.country}"/></div>
            <div class="col-10">${vote.name}</div>
          </div>`;
          result += tmpl_row;
        });
        $("#recent_votes").replaceWith(result);
        $("#recent_votes_container").show();
      });
  }
}

export default RecentVotes;
