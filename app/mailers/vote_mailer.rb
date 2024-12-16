class VoteMailer < ApplicationMailer
  def sign_up(vote)
    @vote = vote
    attachments.inline["earth.jpg"] = File.read(Rails.root.join("app/assets/images/earth.jpg"))
    mail(to: vote.email, subject: _("Thank you for signing the Unite the Armies petition"))
  end

  # = params
  # inviter_name:  name of the inviter
  # name: name of the invited
  # email: email of the invited
  # language: language of the invitation letter
  def email_invite(options)
    unless @inviter_name = options[:inviter_name]
      Rails.logger.error("No inviter name")
      return
    end
    unless @name = options[:name]
      Rails.logger.error("No name")
      return
    end
    unless email = options[:email]
      Rails.logger.error("No email")
      return
    end
    unless language = options[:language]
      Rails.logger.error("No language")
      return
    end
    unless @token = options[:token]
      Rails.logger.error("No token")
      return
    end

    old_locale = I18n.locale
    value = Language.locale(language.to_s)
    if value.blank?
      Rails.logger.error("No language")
      return
    end
    I18n.locale = value
    mail(to: email, subject: _(UNITE_TITLE))
    I18n.locale = old_locale
  end

  # Send vote emails to admins
  #
  # After config.sent_count new votes, vote emails are sent as a list to admins.
  def emails_to_admins(votes)
    unless votes
      Rails.logger.error("Votes is blank")
      return
    end

    @votes = votes

    mail_to = Rails.configuration.x.backup_email
    mail(to: mail_to, subject: "Unite The Armies - allekirjoittajat", cc: "info@jonitoyryla.eu")
  end

  def new_comment(comment)
    @comment = comment
    old_locale = I18n.locale
    I18n.locale = "fi"
    mail_to = Rails.configuration.x.comment_target_email
    mail(to: mail_to, subject: "Unite The Armies - uusi kommentti")
    I18n.locale = old_locale
  end

  # Confirm that email used voting exists
  def confirmation
    @vote = params[:vote]
    @url = params[:url]
    mail(to: @vote.email, subject: _("Confirm Your vote for Unite the Armies - Save the Planet"))
  end
end
