class VotesController < ApplicationController
  helper_method :country_code
  helper_method :country_votes

  def new
    clear

    @vote = Vote.new
    respond_to do |format|
      format.html do
        if request.xhr?
          render layout: false
        end
      end
    end
  end

  # Send email invitation from a vote view
  def email_invite
    unless encoded_token = params[:token]
      Rails.logger.debug("VotesController#email_invite: No token")
      redirect_to locale_root_path
      return
    end

    decoded_token = decode_token(encoded_token)
    unless decoded_token
      Rails.logger.debug("VotesController#email_invite: Invalid token, token: #{decoded_token}")
      redirect_to locale_root_path
    end

    vote_id = decoded_token["vote_id"]
    unless vote_id
      Rails.logger.debug("VotesController#email_invite: vote_id: #{vote_id}, decoded_token: #{decoded_token}")
      redirect_to locale_root_path
    end

    vote = Vote.find_by_id(vote_id)
    unless vote && vote.valid?
      flash[:warning] = _("There was an error")
      redirect_to locale_root_path
      return
    end

    if params[:email] != params[:email_repeat]
      Rails.logger.debug("VotesController#email_invite: Emails do not match")
      flash[:warning] = _("Emails do not match")
      redirect_to locale_root_path
      return
    end

    unless verify_captcha
      flash[:warning] = _("There was an error with human verifying")
      redirect_to locale_root_path
      return
    end

    @vote = vote
    # Share a vote with ActionMailer. If everything is ok, return 200.
    @share_valid = @vote.email_invite(params)

    respond_to do |format|
      format.html do
        if @share_valid
          flash[:success] = _("Invitation has been sent, thank you!")
          head :ok
        else
          flash[:warning] = _("There was an error")
          head :bad_request
        end
      end
    end
  end

  # Add parent vote id to session and redirect to new vote.
  def add_parent
    decoded_token = decode_token(params[:token])
    unless decoded_token
      Rails.logger.error("Vote#add_parent: Invalid token, token: #{params[:token]}")
      redirect_to locale_root_path
      return
    end

    vote = Vote.where(id: decoded_token["vote_id"]).first
    if vote
      session[:parent_vote_id] = vote.id
    end

    redirect_to action: :new, locale: locale
  end

  # If session votes[:parent_id] exists, add parent to this vote
  def create
    unless vote_params[:email_repeat] === vote_params[:email]
      flash[:warning] = _("Emails do not match")
      redirect_to new_vote_path(locale: locale)
      return
    end

    unless verify_captcha
      flash[:warning] = _("There was an error with human verifying")
      redirect_to new_vote_path(locale: locale)
      return
    end

    if request.xhr?
      head :gone
      return
    end

    @vote = Vote.new(vote_params)
    @vote.ip = request.env["REMOTE_ADDR"]

    unless @vote.valid?
      error = []
      @vote.errors.full_messages.each do |msg|
        error << msg
      end

      flash[:warning] = error.join(", ")
      # redirect_to new_vote_path(locale: locale)

      render :new, status: :bad_request
      return
    end


    # If session contains parent vote id, add this vote to parent vote
    # votes association.
    if session[:parent_vote_id]
      parent_vote = Vote.where(id: session[:parent_vote_id])[0]
      # should parent_vote be confirmed vote?
      parent_vote.votes << @vote if parent_vote
    end

    @vote.save if @vote.new_record?

    # Remove session key after succesfull save
    if @vote.valid?
      session.delete :parent_vote_id

      # If sent_count amount of votes is added after last backup email,
      # send a backup email.
      Vote.emails_to_admins
    end

    respond_to do |format|
      format.html do
        if @vote.valid?
          # flash[:success] = _("Thank you for your vote!")

          flash[:info] = _("Your vote is added but email is not yet confirmed. Please check your email.")
          redirect_to waiting_path(locale: locale, id: @vote.id)
        else
          flash[:warning] = "There was an error while adding your vote"
          # redirect_to new_vote_path(locale: locale, anchor: "sign")
          Rails.logger.error("There was an error while adding vote, params: #{vote_params.inspect} errors: #{@vote.errors.inspect}")
          render :new
        end
      end
    end
  end

  # Info page to go confirm email
  #
  # Parameters:
  # - email
  def waiting
    unless params[:id]
      flash[:warning] = _("There was an error")
      Rails.logger.error("Vote.waiting: No email")
      redirect_to new_vote_path(locale: locale)
      return
    end

    begin
      vote_id = params[:id].to_i
    rescue
      flash[:warning] = _("There was an error")
      Rails.logger.error("Vote.waiting: Invalid email")
      redirect_to new_vote_path(locale: locale)
      return
    end

    vote = Vote.find_by_id(vote_id)
    unless vote
      flash[:warning] = _("There was an error")
      Rails.logger.error("Vote.waiting: Vote not found")
      redirect_to new_vote_path(locale: locale)
      return
    end

    if vote.email_confirmed
      flash[:warning] = _("Email is already registered.")
      Rails.logger.error("Vote.waiting: Email is already registered.")
      redirect_to new_vote_path(locale: locale)
      return
    end

    # Send confirm emails only once per 5 minutes
    #
    # TODO:
    # => testi && siirrä helperiin (?)
    # confirm_email_sent = session[:confirm_email_sent].try(:to_time)
    # if confirm_email_sent && Time.now - confirm_email_sent < 5.minutes
    #   wait_left = (5.minutes - (Time.now - confirm_email_sent)) / 60
    #   wait_left_minutes = wait_left.to_i
    #   wait_left_seconds = ((wait_left - wait_left_minutes)*60).to_i
    #   puts "wait_left: #{wait_left}, wait_left_minutes: #{wait_left_minutes}, wait_left_seconds: #{wait_left_seconds}"
    #   flash[:warning] = _("Please wait #{wait_left_minutes}min #{wait_left_seconds.to_i}sec before sending another email")
    #   return
    # end

    if wtl = helpers.waiting_time_left
      flash[:warning] = _("Please wait #{wtl[:min]}min #{wtl[:sec]}sec before sending another email")
      return
    end
    session[:confirm_email_sent] = Time.now

    VoteMailer.with(vote: vote, url: base_url).confirmation.deliver_now
  end

  def index
    @votes = VoteCount.all
    @sorted_votes = @votes.sort { |a, b| b.count <=> a.count }
  end

  # Do not return votes which has created_at in future
  def recently_added
    @votes = Vote.select(:id, :country, :name, :created_at).where("email_confirmed IS NOT NULL and spam = 0").order(created_at: :desc).limit(6)
    votes = @votes.map do |vote|
      vote_h = vote.attributes.to_h
      vote_h[:ago] = vote.ago
      vote_h
    end
    render json: votes.to_json
  end

  def clear
    session.delete :current_vote_id
  end

  def show
    decoded_token = decode_token(params[:token])
    unless decoded_token
      Rails.logger.error("Vote#show: Invalid token, token: #{params[:token]}")
      redirect_to locale_root_path
      return
    end
    vote = Vote.where(id: decoded_token["vote_id"]).first
    unless vote
      flash[:warning] = _("There was an error")
      redirect_to locale_root_path, status: :bad_request
      return
    end
    unless vote.email_confirmed
      redirect_to locale_root_path
      return
    end

    @vote = Vote.where(id: decoded_token["vote_id"]).first
    if @vote.blank?
      redirect_to votes_path(locale: locale)
      return
    end

    # Store current vote to session to allow commenting in contex of
    # this vote.
    session[:current_vote_id] = @vote.id

    @votes_count = @vote.votes_count ||= 0
  end

  # Link is sent to given email. User has to confirm that email exists.
  def confirm
    decoded_token = decode_token(params[:token])
    unless decoded_token
      Rails.logger.error("Vote#confirm: Invalid token, token: #{params[:token]}")
      redirect_to locale_root_path
      return
    end
    vote = Vote.where(id: decoded_token["vote_id"]).first
    unless vote
      flash[:warning] = _("There was an error")
      redirect_to locale_root_path, status: :bad_request
      return
    end
    if vote.email_confirmed
      redirect_to vote_path(locale: locale, token: vote.encoded_payload)
      return
    end

    vote.email_confirmed = Time.now
    vote.save

    VoteMailer.with(vote: vote).sign_up.deliver_later
    flash[:success] = _("Your email has been confirmed")
     redirect_to vote_path(locale: locale, token: vote.encoded_payload)
  end

  private

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

  def language_code
    return "en" unless language_code_full
    language_code_full.split("-")[0]
  end

  def language_code_full
    http_accept_language.user_preferred_languages.first
  end

  def vote_params
    params.require(:vote).permit(:name, :email, :email_repeat, :country)
  end

  def verify_captcha
    captcha = params["g-recaptcha-response"]
    return true if Rails.env.test?
    return false if captcha.blank?
    RecaptchaVerifier.verify(captcha)
  end
end
