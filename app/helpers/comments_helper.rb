module CommentsHelper

  def topics
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

  ## Topics to javascript
  # this is printed at comments/new.
  def topics_to_js
    result = {}
    topics.keys.sort { |a, b| a <=> b }.map { |key|
      result[key] = {
        header: topics[key][:header],
        description: topics[key][:description]
      }
    }
    result.to_json.html_safe
  end

  ## Comment languages
  #
  # TODO: could be only translated text "In english", "Suomeksi", ...
  def comment_language lang
    result = <<~HTML
    <div class="language_container" onclick='comment.setLanguage(this, "#{lang[0]}","#{lang[1]}")'>
      <div class="language">
        <p>#{lang[1]}</p>
        <p>#{Language.translate(lang[0], "Save the planet") }</p>
      </div>
    </div>
    HTML
    result.html_safe
  end

  def comment_languages
    Language.sorted_un_languages.map do |option|
      comment_language option
    end.join.html_safe
  end

  def comment_topic topic
    result = <<~HTML
    <div class="topic_container topic_#{topic}" title="#{topic}" onclick="comment.setTopic(this, '#{topic}')">
      <div class="topic">
      <div class="topic_text">
        <p class="topic_header">#{topics[topic][:header]}</p>
        <p class="topic_description">#{topics[topic][:description]}</p>
      </div>
      </div>
    </div>
    HTML
    result.html_safe
  end

  def comment_topics
    topics.keys.map do |topic|
      comment_topic topic
    end.join.html_safe
  end

end
