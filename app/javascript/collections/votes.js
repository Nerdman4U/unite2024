/*
 * decaffeinate suggestions:
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
const Votes = (UniteTheArmies.Collections.Votes = class Votes extends (
  Backbone.Collection
) {
  static initClass() {
    this.prototype.model = UniteTheArmies.Models.Vote;
  }
});
Votes.initClass();
