#require "i18n/backend/fallbacks"
#I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

#FastGettext.add_text_domain('unite-the-armies', :path => File.join(Rails.root,'config/locales'), :type => :po)
FastGettext.text_domain = 'unite-the-armies'
FastGettext.available_locales = ['en','es','fr','ar','ru','zh','fi']
#FastGettext.available_locales = ['en']
FastGettext.locale = 'en'
FastGettext.add_text_domain('unite-the-armies', :path => File.join(Rails.root,'config/locales'))
FastGettext.default_text_domain = 'unite-the-armies'

