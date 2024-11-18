class VoteMailer < ApplicationMailer

  def sign_up(vote)
    @vote = vote
    attachments.inline['earth.jpg'] = File.read(Rails.root.join("app/assets/images/earth.jpg"))
    mail(to: vote.email, subject: _("Thank you for signing the Unite the Armies petition"))
  end

  # = params
  # inviter_name:  name of the inviter
  # name: name of the invited
  # email: email of the invited
  # language: language of the invitation letter
  def email_invite(options)
    return unless @inviter_name = options[:inviter_name]
    return unless @name = options[:name]
    return unless email = options[:email]
    return unless language = options[:language]
    return unless @token = options[:token]

    old_locale = I18n.locale
    value = Language.locale(language.to_s)
    if value.blank?
      Rails.logger.error("No language")
      return
    end
    I18n.locale = value
    mail(to: email, subject: _('Invitation to Save the World - Unite the Armies'))
    I18n.locale = old_locale
  end

  def vote_backup votes_to
    # allekirjoittajat xx - yy esim. 1200-1300

    unless votes_to
      Rails.logger.error("Votes_to is blank")
      return
    end

    votes_from = UaSetting.instance.sent_at || Vote.first.created_at
    @votes = Vote.where(created_at: votes_from..votes_to).order(:created_at)

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
end


