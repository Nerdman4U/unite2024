class TokensController < ApplicationController
  def new
    @slider = Slider.new({
      name: "new_token",
      fullscreen: true,
      navigation: false,
      slides: [{
        name: "winter-trail",
        headers: {
          h1: [_("Get to your private vote")],
        },
        res: [640,960,1024,1280,1920,2048,3072,4000,5000,6000],
        type: 'jpg',
        default: 1024,
        alt: _("Snowy tree"),
        decorators: ["headers", "image"]
      }]
    })

  end

  # Create token to view private vote.
  def create
    email = params[:email]
    if email.blank?
      Rails.logger.error("Vote#token: Email is blank")
      add_flash :warning, _("There was an error")
      redirect_to locale_root_path
      return
    end
    vote = Vote.where(email: email, spam: false).first
    unless vote
      Rails.logger.error("Vote#token: No vote")
      add_flash :warning, _("Email was not found")
      redirect_to locale_root_path
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
