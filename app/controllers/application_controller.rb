class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :add_flash_to_header
  before_action :set_locale

  private

  def add_flash_to_header
    # only run this in case it's an Ajax request.
    return unless request.xhr?
    # add flash to header
    response.headers['X-Flash'] = flash.to_h.to_json
    # make sure flash does not appear on the next page
    flash.discard
  end

  def set_locale
    FastGettext.text_domain = 'unite-the-armies'
    FastGettext.available_locales = Language::LOCALES.values

    # accept only valid locale values
    loc = Language::LOCALES.values.index(params[:locale].try(:to_sym)).nil? ? nil : params[:locale]

    FastGettext.set_locale(
                           loc ||
                           session[:locale] ||
                           request.env['HTTP_ACCEPT_LANGUAGE'] || :en
                           )
    if session[:locale] and (session[:locale].to_sym != I18n.locale)
      puts "Clearing cache, session:#{session[:locale]} locale:#{I18n.locale}"
      Rails.cache.clear
    end
    session[:locale] = I18n.locale = FastGettext.locale
  end

end
