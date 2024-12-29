import RecentVotes from RAILS_ASSET_URL("./unitethearmies/recent-votes.js");

class UniteTheArmies {
  constructor() {
    this.recent_votes = new RecentVotes();
  }

  init() {
    this.loadVotes();
  }

  loadVotes() {
    this.recent_votes.loadVotes();
  }

  get comment () {
    return this.data.comment;
  }

}

export default UniteTheArmies;
