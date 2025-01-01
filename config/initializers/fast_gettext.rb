FastGettext.text_domain = "unite-the-armies"
FastGettext.available_locales = [ :ar, :zh, :en, :fr, :ru, :es, :de, :sv, :fi ]
FastGettext.default_locale = :en
FastGettext.add_text_domain("unite-the-armies", path: File.join(Rails.root, "config/locales"))
FastGettext.default_text_domain = "unite-the-armies"
