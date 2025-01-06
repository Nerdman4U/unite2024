module Language
  class Base
    LOCALES = {
      :ar => :arabic,
      :zh => :chinese,
      :en => :english,
      :fr => :french,
      :ru => :russian,
      :es => :spanish,
      :fi => :finnish,
      :de => :german,
      :sv => :swedish
    }

    # Return a locale code
    #
    # @param [string|symbol] value language identifier i.e. finnish
    def self.locale value
      return :en if value.blank?
      return :en unless value.is_a?(String) || value.is_a?(Symbol)
      return :en unless LOCALES.values.include? value.to_sym
      LOCALES.key(value.to_sym)
    end

    def self.identifier locale
      LOCALES[locale.to_sym]
    end

    def self.name locale
      identifier(locale).upcase
    end

    ## Translate
    #
    # >> Language::UI.translate(:fi, "English")
    # @return [string] translated language name
    def self.translate locale, name
      raise ArgumentError if locale.blank? || name.blank?
      current_locale = FastGettext.locale
      FastGettext.locale = locale
      translated = _(name)
      FastGettext.locale = current_locale
      translated
    end

    # def self.locales_list
    #   LOCALES.values.map { |l| l.to_s }.sort { |a, b| a <=> b }
    # end
    # def self.locales_list
    #   FastGettext.available_locales.map { |l| l.to_s }.sort { |a, b| a <=> b }
    # end

    # @param [string] locale ISO-639 language code
    def self.valid? locale
      return false if locale.blank?
      return false unless locale.is_a?(String) || locale.is_a?(Symbol)
      locales.include?(locale.to_s)
    end

    # @param [string] identifier downcase language name i.e. finnish.
    def self.valid_identifier? identifier
      return false if identifier.blank?
      return false unless identifier.is_a?(String) || identifier.is_a?(Symbol)
      identifiers.include?(identifier.to_sym)
    end

    def self.valid_name? name
      return false if name.blank?
      return false unless name.is_a?(String) || name.is_a?(Symbol)
      names.include?(name.to_s)
    end

    # @return [Array] list of capitalized language identifier strings
    def self.names
      identifiers.sort.map { |name| name.capitalize.to_s }
    end
    def self.identifiers
      locales.map {|locale| LOCALES[locale.to_sym].downcase }
    end

  end

  class UN < Base
    def self.locales
      %w(ar zh en fr ru es)
    end
    def self.translate locale, name
      raise ArgumentError if locale.blank? || name.blank?
      raise ArgumentError unless self.locales.include?(locale.to_s)
      super
    end

    ## @return [Array] list of [name, identifier(symbol)]
    def self.sorted_un_languages
      names.sort.map { |name| [name, name.downcase.to_sym] }
    end
  end

  class UI < Base
    def self.locales
      unless FastGettext && FastGettext.available_locales
        return [ :ar, :zh, :en, :fr, :ru, :es, :de, :sv, :fi ]
      end
      FastGettext.available_locales.map { |l| l.to_s }.sort { |a, b| a <=> b }
    end
  end

end