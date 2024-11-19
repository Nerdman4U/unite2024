/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const VotesShow = (UniteTheArmies.Views.VotesShow = class VotesShow extends (
  Backbone.View
) {
  static initClass() {
    this.prototype.template = JST["votes/show"];
  }

  render() {
    this.model.calculateAgo();
    this.$el.html(this.template(this.model.attributes));
    return this;
  }
});
VotesShow.initClass();
