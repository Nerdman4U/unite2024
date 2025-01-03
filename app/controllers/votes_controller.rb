class VotesController < ApplicationController
  helper_method :country_votes

  def index
    @votes = VoteCount.all
    @sorted_votes = @votes.sort { |a, b| b.count <=> a.count }
  end

  ## Create a new vote
  #
  # Parameters:
  # - vote
  # - parent_vote :: public_token of parent vote
  #
  def new
    @vote = Vote.new
    @parent_vote = Vote.unspam.confirmed.find_by_md5_secret_token(params[:parent_vote]) if params[:parent_vote]

    respond_to do |format|
      format.html do
        if request.xhr?
          render layout: false
        end
      end
    end
  end

  def show
    token = params[:token]
    unless token
      redirect_to new_token_url
      return
    end
    decoded_token = decode_token(params[:token])
    unless decoded_token
      Rails.logger.error("Vote#show: Invalid token, token: #{params[:token]}")
      redirect_to new_token_url
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

    @votes_count = @vote.votes.size ||= 0
    @comments_count = @vote.comments.size ||= 0
  end

  # Send email invitation from a vote view
  def invite
    unless logged_in?
      flash[:warning] = _("You need to be logged in")
      redirect_to locale_root_path
      return
    end

    if params[:email] != params[:email_repeat]
      Rails.logger.error("VotesController#invite: Emails do not match")
      flash[:warning] = _("Emails do not match")
      # redirect_to locale_root_path
      redirect_to vote_path(locale: locale, token: current_vote.encoded_payload)
      return
    end

    if params[:email].blank? || params[:email].match(URI::MailTo::EMAIL_REGEXP).nil?
      Rails.logger.error("VotesController#invite: Invalid email")
      flash[:warning] = _("Email is not valid")
      redirect_to vote_path(locale: locale, token: current_vote.encoded_payload)
      return
    end

    unless verify_captcha
      flash[:warning] = _("There was an error with human verifying")
      redirect_to locale_root_path
      return
    end

    unless @vote = current_vote
      flash[:warning] = _("There was an error")
      Rails.logger.error("VotesController#invite: Vote not found")
      redirect_to locale_root_path
      return
    end

    # Share a vote with ActionMailer. If everything is ok, return 200.
    @share_valid = @vote.invite(params)

    respond_to do |format|
      format.html do
        if @share_valid
          flash[:success] = _("Invitation has been sent, thank you!")
          redirect_to vote_path(locale: locale, token: @vote.encoded_payload)
        else
          flash[:warning] = _("There was an error")
          redirect_to vote_path(locale: locale, token: @vote.encoded_payload)
        end
      end
    end
  end

  ## Create a new vote
  #
  # Parameters:
  # - vote
  #   - email
  #   - email_repeat
  #   - country
  #   - name
  # - parent_vote :: public_token of parent vote
  #
  def create
    logout!

    if params[:vote][:email] != params[:vote][:email_repeat]
      Rails.logger.error("Vote#create: Emails do not match")
      flash[:warning] = _("Emails do not match")
      redirect_to new_vote_path(locale: locale)
      return
    end

    unless verify_captcha
      flash[:warning] = _("There was an error with human verifying")
      redirect_to new_vote_path(locale: locale)
      return
    end

    @vote = Vote.new(vote_params)
    @vote.ip = request.env["REMOTE_ADDR"]
    @vote.save

    unless @vote.valid?
      Rails.logger.error("Vote#create: Invalid vote, errors: #{@vote.errors.full_messages}")
      flash[:warning] = validation_errors(@vote)
      redirect_to new_vote_path(locale: locale)
      # render :new, status: :bad_request <= kumpi parempi?
      return
    end

    if params[:parent_vote]
      parent_vote = Vote.unspam.confirmed.find_by_md5_secret_token(params[:parent_vote])
      parent_vote.votes << @vote if parent_vote
    end

    # New vote has been added.
    #
    # 1) Notify admins
    # If sent_count amount of votes is added after last backup email,
    # send a backup email.
    #
    # 2) Nofity parent vote
    # If parent vote exists, notify owner.
    #
    uas = UaSetting.instance
    uas.send_notify_email!

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:info] = _("Your vote is added but email is not yet confirmed. Please check your email.")
          redirect_to waiting_path(locale: locale, token: @vote.public_token)
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
    unless params[:token]
      flash[:warning] = _("There was an error")
      Rails.logger.error("Vote.waiting: No token")
      redirect_to new_vote_path(locale: locale)
      return
    end

    # vote = Vote.where(md5_secret_token: params[:token], spam: false, email_confirmed: nil).first
    vote = Vote.unspam.unconfirmed.find_by_md5_secret_token(params[:token])
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

    if wtl = helpers.waiting_time_left
      flash[:warning] = _("Please wait #{wtl[:min]}min #{wtl[:sec]}sec before sending another email")
      return
    end
    session[:confirm_email_sent] = Time.now

    confirm_url = confirm_url(token: vote.encoded_payload)
    VoteMailer.with(vote: vote, url: base_url, confirm_url: confirm_url).confirmation.deliver_now
  end

  # Do not return votes which has created_at in future
  def recently_added
    @votes = Vote.select(:id, :country, :name, :created_at).confirmed.unspam.order(created_at: :desc).limit(6)
    votes = @votes.map do |vote|
      vote_h = vote.attributes.to_h
      vote_h[:ago] = vote.ago
      vote_h
    end
    render json: votes.to_json
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
