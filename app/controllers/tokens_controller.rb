class TokensController < ApplicationController
  def new
  end

  # Create token to view private vote.
  def create
    email = params[:email]
    if email.blank?
      Rails.logger.error("Vote#token: Email is blank")
      add_flash :warning, _("There was an error")
      redirect_to locale_root_path, status: :bad_request
      return
    end
    vote = Vote.where(email: email, spam: false).first
    unless vote
      Rails.logger.error("Vote#token: No vote")
      add_flash :warning, _("Email was not found")
      redirect_to locale_root_path, status: :bad_request
      return
    end
    unless vote.email_confirmed
      Rails.logger.error("Vote#token: Email is not confirmed")
      add_flash :warning, _("Email is not confirmed")
      add_flash :info, _("Please check your email")
      redirect_to waiting_path(locale: locale, id: vote.id)
      return
    end

    token = vote.encoded_payload
    VoteMailer.with(vote: vote, token: token).token.deliver_later
    # VoteMailer.with(vote: vote).token.deliver_later

    add_flash :success, _("Your private link has been sent to your email")
    redirect_to locale_root_path
  end

  def destroy
    logout!

    add_flash :success, _("You have been logged out")
    redirect_to locale_root_path
  end
end
