/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const VotesIndex = (UniteTheArmies.Views.VotesIndex = class VotesIndex extends (
  Backbone.View
) {
  static initClass() {
    this.prototype.template = JST["votes/index"];
  }

  renderVotes() {
    return this.collection.each((model) => {
      const view = new UniteTheArmies.Views.VotesShow({ model });
      const row = view.render().$el;
      return this.$el.find("tbody").prepend(row.html());
    });
  }

  render() {
    this.$el.html(this.template());
    this.renderVotes();
    return this;
  }
});
VotesIndex.initClass();
