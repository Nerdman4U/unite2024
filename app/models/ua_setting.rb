## UaSetting
#
# This model holds settings for Unite The Armies.
#
# Database:
# - sent_at: Time when last backup email was sent.
# - vote_count: DEPRECATED
# - sent_count: DEPRECATED
#
# Config files:
# - config/environments : x.send_count
#   - how many votes until message is sent to administrator.
#   => this is used at votes_controller.
#
# Problems:
# - if votes are removed how to find new votes with small ids?
#   => votes are not removed.
#   - should select data ordered by created_at, this should solve.

class UaSetting < ApplicationRecord
  @@instance = nil

  def self.instance
    @@instance ||= first || new
  end

  ## Votes after notify
  #
  # Return votes to be send to admins in next notify email.
  # self.sent_at: time when last notify email was sent.
  def votes_after_notify
    return Vote.all if self.sent_at.nil?
    Vote.where("created_at > ?", self.sent_at).order(created_at: :desc)
  end

  def send_notify_email!
    return unless send_notify_email?
    uas = UaSetting.instance
    VoteMailer.with(votes: votes_after_notify).emails_to_admins.deliver_now
    self.sent_at = Time.now
    self.save
  end

  def send_notify_email?
    return false if Rails.configuration.x.votes_in_notify_email.blank?
    Rails.configuration.x.votes_in_notify_email.to_i - votes_after_notify.count < 1
  end

  def version
    require "yaml"
    if File.exist?(".cz.yaml")
      data = open(".cz.yaml").read()
      data = YAML.load(data)
      data["commitizen"]["version"]
    else
      "unknown"
    end
  end
end
