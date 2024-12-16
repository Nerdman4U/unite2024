require "ostruct"
require "digest/md5"

class Vote < ApplicationRecord
  # include Humanizer
  # require_human_on :create, :unless => :bypass_humanizer
  attr_accessor :bypass_humanizer
  attr_reader :ago
  attr_accessor :email_repeat

  validates :name, presence: true
  validates :country, presence: true
  validates :email, confirmation: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :ip, presence: true
  validates_format_of :ip, with: /\A(\d{1,3}\.){3}\d{1,3}\z/
  validate :validate_country_code

  after_initialize :strip_email
  after_initialize :downcase_country_code
  before_save :add_vote_count

  has_many :votes, foreign_key: :vote_id
  has_many :comments, foreign_key: :vote_id
  # belongs_to :vote, counter_cache: true

  # before_save :add_secret_token
  # before_save :add_secret_confirm_hash

  def ago
    showHours = I18n.locale == :en || I18n.locale == :fi
    diff = TimeDifference.between(Time.zone.now, created_at).in_each_component
    diff = OpenStruct.new(diff)
    if diff.seconds < 60
      ago = "%.0f" % diff.seconds.floor
      ago_string = diff.seconds < 2 ? _("second") : _("seconds")
    elsif diff.minutes < 60
      ago = "%.0f" % diff.minutes.floor
      ago_string = diff.minutes < 2 ? _("minute") : _("minutes")
    elsif diff.hours < 24 && showHours
      ago = "%.0f" % diff.hours.floor
      ago_string = diff.hours < 2 ? _("hour") : _("hours")
    else
      ago = showHours ? ("%.0f" % diff.days.floor) : ("%.2f" % diff.days)
      ago_string = diff.days < 2 ? _("day") : _("days")
    end
    "#{ago} #{ago_string}"
  end

  # Strip email of whitespace
  def strip_email
    self.email = email.strip if self.has_attribute?(:email) && email
  end

  # Country code is always saved with downcased letters
  def downcase_country_code
    self.country.downcase! unless country.blank?
  end

  def validate_country_code
    if country.blank? || Country.codes.index(country.upcase).nil?
      errors.add(:country, "is not valid")
    end
  end

  def votes_missed
    VoteCount.target_vote_count - VoteCount.total
  end

  # Vote#order_number as the total number of all votes
  def add_vote_count
    Rails.logger.debug("Adding vote count for #{self.inspect}")
    return unless self.new_record?
    # puts "adding vote count for #{self.inspect}"
    VoteCount.add_vote(self)
    self.order_number = VoteCount.total
  end

  # We do not allow duplicate tokens, lets be sure there is no equal
  # token already in database.
  def add_secret_token
    return if secret_token
    while token = get_secret_token do
      if Vote.where(secret_token: token).blank?
        # digest = Digest::MD5.hexdigest(token)
        self.secret_token = token
        # self.md5_secret_token = digest
        break
      end
    end
  end

  # Secret confirm hash is used to validate an email. It has to be unique.
  def add_secret_confirm_hash
    self.secret_confirm_hash = find_confirm_hash
  end

  def email_invite(options)
    unless options[:name]
      Rails.logger.error("No name")
      return
    end
    unless options[:email]
      Rails.logger.error("No email")
      return
    end
    unless options[:language]
      Rails.logger.error("No language")
      return
    end
    if self.new_record?
      Rails.logger.error("Cannot email invite for new record")
      return
    end
    options = options.merge(inviter_name: name, token: self.encoded_payload)
    VoteMailer.with(options: options).email_invite.deliver_now
  end

  def self.duplicate_confirm_hash?(token)
    !!Vote.where(secret_confirm_hash: token).first
  end

  # Send vote emails to admins.
  #
  # Send config.sent_count new emails to admins.
  #
  def self.emails_to_admins
    uas = UaSetting.instance
    return nil if Rails.configuration.x.sent_count.blank?

    # How many votes has already sent plus votes to be send
    #
    # If VoteCount.total is smaller, exit because there are not enough votes yet.
    total = uas.vote_count.to_i + Rails.configuration.x.sent_count
    return nil unless VoteCount.total >= total
    # puts "Vote.emails_to_admins OK total: #{total} VoteCount.total: #{VoteCount.total}"

    votes = votes_to_be_send_to_admins
    # puts "Vote.send_emails votes.size: #{votes}"

    VoteMailer.with(votes: votes).emails_to_admins.deliver_now

    uas.sent_at = Time.now
    uas.vote_count = VoteCount.total
    uas.save
  end

  def self.votes_from
    UaSetting.instance.sent_at || Vote.order(:created_at).first.created_at
  end

  def self.votes_to_be_send_to_admins(votes_to = Time.now)
    # Time range of votes to be sent.
    # puts "Vote.send_emails votes_from: #{votes_from} votes_to: #{votes_to}"

    # Votes to be send.
    Vote.where(created_at: votes_from..votes_to).order(:created_at)
  end

  def encoded_payload
    return nil if self.new_record?
    payload = {
      vote_id: id,
      exp: (Time.now + 1.week).to_i # This sets the expiration time
    }
    JWT.encode(payload, ENV["UNITE_SECRET_KEY"], "HS256")
  end

  private

  # DEPRECATED
  def secret_hash
    token = "secret: #{Time.now} #{rand(10000)}"
    # puts "secret_hash: #{token}"
    Digest::MD5.hexdigest(token)
  end

  def get_secret_token
    SecureRandom.hex(64)
  end

  # def get_public_token
  #   Digest::MD5.hexdigest(self.secret_token  + "public amazing secret 416")
  # end

  def find_confirm_hash
    while token = secret_hash do
      return token unless Vote.duplicate_confirm_hash?(token)
    end
  end
end
