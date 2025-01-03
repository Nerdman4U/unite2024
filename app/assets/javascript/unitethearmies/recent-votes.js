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
        for (let vote of data) {
          let tmpl_row = `<div class="row recent-vote">
            <div class="col-4">
              <span class="flag-icon flag-icon-${vote.country}"></span>
            </div>
            <div class="col-4">${vote.ago}</div>
            <div class="col-4">${vote.name}</div>
          </div>`;
          result += tmpl_row;
        }
        $("#recent_votes").replaceWith(result);
        $("#recent_votes_container").show();
      });
  }
}

// <image class="flag_small ${vote.country}"/>

export default RecentVotes;
