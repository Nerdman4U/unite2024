module CommentsHelper

  def themes
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

  ## themes to javascript
  # this is printed at comments/new.
  def themes_to_js
    result = {}
    themes.keys.sort { |a, b| a <=> b }.map { |key|
      result[key] = {
        header: themes[key][:header],
        description: themes[key][:description]
      }
    }
    result.to_json.html_safe
  end

  ## Comment languages
  #
  # TODO: could be only translated text "In english", "Suomeksi", ...
  def comment_language lang
    result = <<~HTML
    <div class="language_container" id="language_#{lang[1]}" onclick='comment.setLanguage(this, "#{lang[0]}","#{lang[1]}")'>
      <div class="language_text">
        <p>#{lang[1]}</p>
        <p>#{Language::UI.translate(lang[0], "Save the planet") }</p>
      </div>
    </div>
    HTML
    result.html_safe
  end

  def comment_languages
    Language::UN.sorted_un_languages.map do |option|
      comment_language option
    end.join.html_safe
  end

  def comment_theme theme
    result = <<~HTML
    <div class="theme_container theme_#{theme}" title="#{theme}" onclick="comment.setTheme(this, '#{theme}')">
      <div class="theme">
      <div class="theme_text">
        <p class="theme_header">#{themes[theme][:header]}</p>
        <!-- <p class="theme_description">#{themes[theme][:description]}</p> -->
      </div>
      </div>
    </div>
    HTML
    result.html_safe
  end

  def comment_themes
    themes.keys.map do |theme|
      comment_theme theme
    end.join.html_safe
  end

end
