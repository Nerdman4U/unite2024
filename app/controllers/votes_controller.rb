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

  # Share only with ajax
  def email_invite
    @vote = Vote.where(md5_secret_token: params[:t]).first
    unless @vote
      flash[:error] = _("There was an error")
      head :bad_request
      return
    end

    unless RecaptchaVerifier.verify(params["g-recaptcha-response"])
      flash[:error] = _("There was an error with human verifying")
      head :bad_request
      return
    end

    # Share a vote with ActionMailer. If everything is ok, return 200.
    @share_valid = @vote.email_invite(params)

    respond_to do |format|
      format.html do
        if @share_valid
          flash[:success] = _("Invitation has been sent, thank you!")
          head :ok
        else
          flash[:error] = _("There was an error")
          head :bad_request
        end
      end
    end
  end

  # Add parent vote id to session and redirect to new vote.
  #
  # Use md5 crypted secret token in parameters, this way token cannot be
  # used as a part of the url.
  def add_parent
    vote = Vote.where(md5_secret_token: params[:t]).first
    if vote
      session[:parent_vote_id] = vote.id
    end
    redirect_to action: :new, locale: locale
  end

  # If session votes[:parent_id] exists, add parent to this vote
  def create
    @vote = Vote.new(vote_params)
    @vote.ip = request.env["REMOTE_ADDR"]
    @vote.bypass_humanizer = true if Rails.env.test?

    unless RecaptchaVerifier.verify(params["g-recaptcha-response"])
      redirect_to new_vote_path(locale: locale)
      return
    end

    # If session contains parent vote id, add this vote to parent vote
    # votes association.
    if session[:parent_vote_id]
      parent_vote = Vote.where(id: session[:parent_vote_id])[0]
      parent_vote.votes << @vote if parent_vote
    end

    @vote.save if @vote.new_record?

    # Remove session key after succesfull save
    if @vote.valid?
      session.delete :parent_vote_id

      # If sent_count amount of votes is added after last backup email,
      # send a backup email.
      uas = UaSetting.instance
      total = uas.vote_count.to_i + Rails.configuration.x.send_count
      if VoteCount.total >= total
        uas.send!
      end
    end

    respond_to do |format|
      format.html do
        if request.xhr?
          if @vote.valid?
            VoteMailer.sign_up(@vote).deliver_later
            flash[:success] = _("Thank you for your vote!")
            head :ok
          else
            flash[:error] = _("There was an error while adding your vote")
            head :bad_request
          end
        else
          if @vote.valid?
            VoteMailer.sign_up(@vote).deliver_later
            flash[:success] = _("Thank you for your vote!")
            redirect_to vote_path(locale: locale, secret_token: @vote.secret_token)
          else
            #flash[:error] = "There was an error while adding your vote"
            #redirect_to new_vote_path(locale: locale, anchor: "sign")
            render :new
          end
        end
      end
    end
  end

  def index
    @votes = VoteCount.all
    @sorted_votes = @votes.sort { |a,b| b.count <=> a.count }
  end

  # Do not return votes which has created_at in future
  def recently_added
    @votes = Vote.select(:id, :country,:name, :created_at).where("created_at <= ?", Time.now).last(6)
    votes = @votes.map do |vote|
      vote_h = vote.attributes.to_h
      vote_h[:ago] = vote.ago
      vote_h
    end
    render :json => votes.to_json
  end

  def clear
    session.delete :current_vote_id
  end

  def show
    @vote = Vote.where(secret_token: params[:secret_token]).first
    if @vote.blank?
      redirect_to votes_path(locale: locale)
      return
    end

    # Store current vote to session to allow commenting in contex of
    # this vote.
    session[:current_vote_id] = @vote.id

    @votes_count = @vote.votes_count ||= 0
  end

  private


  # TODO: return default country instead of nil.
  def country_code
    return nil unless request.params
    vote = request.params[:vote] if request.params.has_key?(:vote)
    return nil if vote.blank?
    country_code = vote[:country] if vote.has_key?(:country)
    return nil if country_code.blank?
    #return request[:vote][:country] if request[:vote] and request[:vote][:country]
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
    params.require(:vote).permit(:name, :email, :email_confirmation, :country, :humanizer_answer, :humanizer_question_id)
  end

end
