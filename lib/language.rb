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
    %w(arabic chinese english french russian spanish)
  end

  def self.valid_un_language? identifier
    un_languages.include?(identifier)
  end

  ## Return a list of 2 item lists.
  #
  def self.sorted_un_languages
    un_languages.sort { |a, b| a <=> b }.map { |k| [k.capitalize, k.to_sym] }
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

  def self.locales_list
    LOCALES.values.map { |l| l.to_s }.sort { |a, b| a <=> b }
  end

end
