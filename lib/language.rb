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

  ## Return a list of 2 item lists.
  #
  # First item is language identifier.
  # Second item is a translated humanized literal.
  def self.sorted_un_languages
    un_languages.keys.sort { |a, b| a[0] <=> b[0] }.map { |k| [un_languages[k], k] }
  end

  # Return a locale symbol for language name
  def self.locale(value)
    return :en if value.blank?
    return :en unless value.is_a?(String)
    return :en unless LOCALES[value.to_s]
    LOCALES[value.to_s]
  end

  def self.translate(*args)
    raise ArgumentError if args.size != 2
    current_locale = FastGettext.locale
    FastGettext.locale = args[0]
    translated = _(args[1])
    FastGettext.locale = current_locale
    translated
  end

end
