class UniteTheArmies.Views.VotesShow extends Backbone.View
  template: JST['votes/show']

  render: ->
    this.model.calculateAgo()
    this.$el.html( this.template( this.model.attributes ) )
    this

    