class VotesController < ApplicationController
  helper_method :country_votes

  before_action :require_login, only: [:show]

  def index
    # number_with_delimiter(VoteCount.total)
    @slider = Slider.new({
      name: "votes",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "forest",
        headers: {
          h1: [_("%{count} votes") % { count: VoteCount.total }],
          h2: [_("More work must be done")]
        },
        res: [640,960,1024,1280,1920,2048],
        type: 'jpg',
        default: 640,
        alt: _("Forest"),
        decorators: ["headers", "image"]
      }]
    })

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
    @slider = Slider.new({
      name: "new_vote",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "lenkki-pitkospuilla",
        headers: {
          h1: [_("Support")],
          h2: [_("Radical actions are urgently needed to save our planet.")]
        },
        res: [640,960,1024,1280,1920,2048],
        type: 'jpg',
        default: 640,
        alt: _("At Duckboard"),
        decorators: ["headers", "image"]
      }]
    })

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
    decoded_token = decode_token(params[:token])
    vote = Vote.where(id: decoded_token["vote_id"]).first
    unless vote
      add_flash :warning, _("There was an error")
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

    @slider = Slider.new({
      name: "new_vote",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "bridge-park-garden-japanese",
        headers: {
          h1: [_("Thank you for your support %{name}") % {name: @vote.name}],
          h2: [_("This is your private vote (%s)") % @vote.email]
        },
        res: [640,960,1024,1280,1920,2048],
        type: 'jpg',
        default: 640,
        alt: _("Japanese bridge park garden"),
        decorators: ["headers", "image"]
      }]
    })

    # Store current vote to session to allow commenting in contex of
    # this vote.
    session[:current_vote_id] = @vote.id

    @votes_count = @vote.votes.size ||= 0
    @comments_count = @vote.comments.size ||= 0
  end

  # Send email invitation from a vote view
  def invite
    unless logged_in?
      add_flash :warning, _("You need to be logged in")
      redirect_to locale_root_path
      return
    end

    if params[:email] != params[:email_repeat]
      Rails.logger.error("VotesController#invite: Emails do not match")
      add_flash :warning, _("Emails do not match")
      # redirect_to locale_root_path
      redirect_to vote_path(locale: locale, token: current_vote.encoded_payload)
      return
    end

    if params[:email].blank? || params[:email].match(URI::MailTo::EMAIL_REGEXP).nil?
      Rails.logger.error("VotesController#invite: Invalid email")
      add_flash :warning, _("Email is not valid")
      redirect_to vote_path(locale: locale, token: current_vote.encoded_payload)
      return
    end

    unless verify_captcha
      add_flash :warning, _("There was an error with human verifying")
      redirect_to locale_root_path
      return
    end

    unless @vote = current_vote
      add_flash :warning, _("There was an error")
      Rails.logger.error("VotesController#invite: Vote not found")
      redirect_to locale_root_path
      return
    end

    # Share a vote with ActionMailer. If everything is ok, return 200.
    @share_valid = @vote.invite(params)

    respond_to do |format|
      format.html do
        if @share_valid
          add_flash :success, _("Invitation has been sent, thank you!")
          redirect_to vote_path(locale: locale, token: @vote.encoded_payload)
        else
          add_flash :warning, _("There was an error")
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
      add_flash :warning, _("Emails do not match")
      redirect_to new_vote_path(locale: locale)
      return
    end

    unless verify_captcha
      add_flash :warning, _("There was an error with human verifying")
      redirect_to new_vote_path(locale: locale)
      return
    end

    @vote = Vote.new(vote_params)
    @vote.ip = request.env["REMOTE_ADDR"]
    @vote.save

    unless @vote.valid?
      Rails.logger.error("Vote#create: Invalid vote, errors: #{@vote.errors.full_messages}")
      @vote.errors.full_messages.each do |message|
        add_flash :warning, message
      end
      # redirect_to new_vote_path(locale: locale)
      render :new, status: :bad_request
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
          add_flash :info, _("Your vote is added but email is not yet confirmed. Please check your email.")
          redirect_to waiting_path(locale: locale, token: @vote.public_token)
        else
          add_flash :warning, "There was an error while adding your vote"
          Rails.logger.error("There was an error while adding vote, params: #{vote_params.inspect} errors: #{@vote.errors.inspect}")
          render :new, status: :bad_request
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
      add_flash :warning, _("There was an error")
      Rails.logger.error("Vote.waiting: No token")
      redirect_to new_vote_path(locale: locale)
      return
    end

    # vote = Vote.where(md5_secret_token: params[:token], spam: false, email_confirmed: nil).first
    vote = Vote.unspam.unconfirmed.find_by_md5_secret_token(params[:token])
    unless vote
      add_flash :warning, _("There was an error")
      Rails.logger.error("Vote.waiting: Vote not found")
      redirect_to new_vote_path(locale: locale)
      return
    end

    if vote.email_confirmed
      add_flash :warning, _("Email is already registered.")
      Rails.logger.error("Vote.waiting: Email is already registered.")
      redirect_to new_vote_path(locale: locale)
      return
    end

    @slider = Slider.new({
      name: "waiting",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "wildlife-park-wolf",
        headers: {
          h1: [_("Confirm email sent")],
          h2: [_("Go to your mailbox and click confirmation link on email we just have sent!")]
        },
        res: [640,960,1024,1280,1920,2048],
        type: 'jpg',
        default: 640,
        alt: _("Wildlife Park Wolf"),
        decorators: ["headers", "image"]
      }]
    })

    if wtl = helpers.waiting_time_left
      add_flash :warning, _("Please wait #{wtl[:min]}min #{wtl[:sec]}sec before sending another email")
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
      add_flash :warning, _("There was an error")
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
    add_flash :success, _("Your email has been confirmed")
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
