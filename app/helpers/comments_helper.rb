module CommentsHelper

  def comment_topics
    {
      "administration" => {
        header: "Administration", description: _("The activities of the United Armies must be controlled by a common, international organ.")
      },
      "water" => {
        header: "Water", description: _("The United Armies must ensure sufficient water availability everywhere for the needs of people and life.")
      },
      "climate" => {
        header: "Climate", description: _("The resources and capacity of the United Armies must be directed to reforestation of the deserts."),
      },
      "plastic-waste" => {
        header: "Plastic Waste", description: _("The United Armies must collect the plastic waste from the oceans and shores.")
      },
      "protected-areas" => {
        header: "Protected Areas", description: _("The United Armies must protect the areas reserved for nature.")
      }
    }
  end


end
