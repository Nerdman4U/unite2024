class Language
  LOCALES = {
    "arabic" => :ar,
    "chinese" => :zh,
    "english" => :en,
    "french" => :fr,
    "russian" => :ru,
    "spanish" => :es,
    "finnish" => :fi,
    "german" => :de,
    "swedish" => :se
  }

  # Valid UN language literals.
  def self.un_languages
    {
      arabic: _("Arabic"),
      chinese: _("Chinese"),
      english: _("English"),
      french: _("French"),
      russian: _("Russian"),
      spanish: _("Spanish"),
      finnish: _("Finnish"),
      german: _("German"),
      swedish: _("Swedish")
    }
  end

  def self.sorted_un_languages
    un_languages.keys.sort { |a, b| a[0] <=> b[0] }.map { |k| [k, un_languages[k]] }
  end

  # Return a locale symbol for language name
  def self.locale(value)
    return :en if value.blank?
    return :en unless value.is_a?(String)
    return :en unless LOCALES[value.to_s]
    LOCALES[value.to_s]
  end
end
