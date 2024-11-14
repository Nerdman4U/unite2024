class UniteTheArmies.Views.VotesIndex extends Backbone.View
  template: JST['votes/index']
  
  renderVotes: ->
    this.collection.each (model) => 
      view = new UniteTheArmies.Views.VotesShow(model: model)
      row = view.render().$el
      this.$el.find("tbody").prepend( row.html() )
    
  render: ->
    this.$el.html( this.template() )
    this.renderVotes()
    this
