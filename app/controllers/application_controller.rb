class ApplicationController < ActionController::Base
  FLASH_TYPES = [:success, :warning, :danger, :info]

  include TokenHelper

  around_action :user_tagged_logging

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :add_flash_to_header
  before_action :set_locale

  helper_method :logged_in?
  helper_method :current_vote
  helper_method :country_code
  helper_method :unitethearmies_title
  helper_method :production_server?

  private

  def user_tagged_logging
    if logged_in? && current_vote
      logger.tagged(current_vote.email) do
        yield
      end
    else
      logger.tagged('Anonymous') do
        yield
      end
    end

  end

  # TODO: return default country instead of nil.
  def country_code
    return nil unless request.params
    vote = request.params[:vote] if request.params.has_key?(:vote)
    return nil if vote.blank?
    country_code = vote[:country] if vote.has_key?(:country)
    return nil if country_code.blank?
    # return request[:vote][:country] if request[:vote] and request[:vote][:country]
    country_code
  end

  def add_flash_to_header
    # only run this in case it's an Ajax request.
    return unless request.xhr?
    # add flash to header
    response.headers["X-Flash"] = flash.to_h.to_json
    # make sure flash does not appear on the next page
    flash.discard
  end

  def set_locale
    FastGettext.text_domain = "unite-the-armies"
    FastGettext.available_locales = Language::LOCALES.values

    # accept only valid locale values
    # loc = Language::LOCALES.values.index(params[:locale].try(:to_sym)).nil? ? nil : params[:locale]
    loc = params[:locale] ||
          session[:locale] ||
          extract_locale_from_accept_language_header ||
          :en
    loc = loc.to_sym

    FastGettext.set_locale(loc)
    if session[:locale] and (session[:locale].to_sym != I18n.locale)
      # puts "Clearing cache, session:#{session[:locale]} locale:#{I18n.locale}"
      Rails.cache.clear
    end
    session[:locale] = I18n.locale = FastGettext.locale.to_sym
    # puts "set_locale() loc: #{loc.inspect} session[:locale]: #{session[:locale].inspect} I18n.locale: #{I18n.locale.inspect} FastGettext.locale: #{FastGettext.locale.inspect}"
    session[:locale]
  end

  def extract_locale_from_accept_language_header
    return nil if request.env["HTTP_ACCEPT_LANGUAGE"].blank?
    request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
  end

  def base_url
    request.scheme + "://" + request.host
  end

  def logged_in?
    !!session[:current_vote_id]
  end

  def current_vote
    return unless logged_in?
    begin
      Vote.where(id: session[:current_vote_id]).first
    rescue
      logout
      nil
    end
  end

  def logout!
    return unless logged_in?
    session.delete :current_vote_id
    reset_session
  end

  def unitethearmies_title
    topic = _(UNITE_TITLE)
    subtopic = case controller_name
    when "votes"
      case action_name
      when "show"
        subtopic = _("My vote")
      when "new"
        subtopic = _("New vote")
      when "index"
        subtopic = _("a List of votes")
      end
    when "welcome"
      case action_name
      when "index"
        subtopic = _("Home")
      when "appeal"
        subtopic = _("Appeal")
      when "material"
        subtopic = _("Material")
      end
    when "comments"
      case action_name
      when "index"
        subtopic = _("Comments")
      when "new"
        subtopic = _("New comment")
      when "show"
        subtopic = _("Comment")
      end
    when "tokens"
      case action_name
      when "new"
        subtopic = _("Login")
      when "index" && method == "DELETE"
        subtopic = _("Logout")
      end
    end

    #puts "controller: #{controller_name.inspect} action: #{action_name.inspect}"
    #puts "subtopic: #{subtopic.inspect}"
    subtopic.blank? ? topic : "#{subtopic} (#{topic})"
  end

  def validation_errors model
    return "" if model.nil?
    return "" if model.errors.empty?
    model.errors.full_messages.join(", ")
  end

  def production_server?
    raise InternalServerError unless request.hostname
    !request.hostname.match?("localhost")
  end

  # Add flash message
  #
  # flash[:type] is an array to allow multiple messages of the same type.
  #
  # @param [Symbol] type
  # @param [String] full_message A Message
  # @return [Boolean]
  def add_flash type, full_message
    return false if type.blank?
    return false if full_message.blank?
    return false unless FLASH_TYPES.include?(type)

    if full_message.is_a?(Array)
        full_message.flatten!
        full_message = full_message.join("")
    end

    flash[type] = flash[type] ? flash[type] << full_message : [full_message]
  end
end
