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
    console.log("recent:", RUN_RECENT_VOTES, this.doLoad());
    fetch("/votes/recently_added.json")
      .then((response) => response.json())
      .then((data) => {
        let result = "";
        data.forEach(function (vote) {
          let tmpl_row = `<tr>
            <td><image class="flag_small ${vote.country}"/></td>
            <td>${vote.name}</td>
          </tr>`;
          result += tmpl_row;
        });
        $("#recent_votes tbody").replaceWith(result);
      });
  }
}

export default RecentVotes;
