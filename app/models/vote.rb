require "ostruct"
require "digest/md5"

class Vote < ApplicationRecord
  scope :spam, -> { where(spam: true) }
  scope :unspam, -> { where(spam: false) }
  scope :confirmed, -> { where.not(email_confirmed: nil) }
  scope :unconfirmed, -> { where(email_confirmed: nil) }

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
  before_save :set_order_number

  has_many :votes, foreign_key: :vote_id
  has_many :comments, foreign_key: :vote_id
  belongs_to :vote, optional: true #, counter_cache: true

  before_save :set_private_token # votes.secret_token
  before_save :set_public_token # votes.md5_secret_token

  # Ago
  #
  # How long ago vote was created as a humanized string.
  #
  # @return [string]
  def ago
    showHours = I18n.locale == :en || I18n.locale == :fi
    diff = TimeDifference.between(Time.zone.now, created_at).in_each_component
    diff = OpenStruct.new(diff)
    # puts "Diff diff.seconds: #{diff.seconds} diff.minutes: #{diff.minutes} diff.hours: #{diff.hours} diff.days: #{diff.days}"
    if created_at > Time.now
      ago = nil
      ago_string = "Now"
    elsif diff.seconds < 30
      ago = nil
      ago_string = "Now"
    elsif diff.seconds < 60
      ago = "%.0f" % diff.seconds.floor
      ago_string = diff.seconds < 2 ? _("second") : _("seconds")
    elsif diff.minutes < 60
      ago = "%.0f" % diff.minutes.floor
      ago_string = diff.minutes < 2 ? _("minute") : _("minutes")
    elsif diff.hours < 24 && showHours
      ago = "%.0f" % diff.hours.floor
      ago_string = diff.hours < 2 ? _("hour") : _("hours")
    elsif diff.days < 2
      ago = nil
      ago_string = _("Yesterday")
    elsif diff.days <= 7
      ago = "%.0f" % diff.days.floor
      ago_string = _("days")
    else
      ago = nil
      ago_string = _("More than a week.")
    end
    [ago, ago_string].filter(&:present?).join(" ")
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

  # public: add vote count to VoteCount.
  #
  # Vote count must be added after confirmed vote is saved.
  #
  # Vote#order_number as the total number of all votes (if this is
  # last vote).
  #
  # Returns nothing.
  def add_vote_count
    # do not add vote count if spam and unless confirmed.
    return if self.email_confirmed.nil?
    return if self.spam

    # do not add vote count again unless email_confirmed has changed
    # which should never change.
    return unless will_save_change_to_email_confirmed?

    VoteCount.add_vote(self)
  end
  def set_order_number
    return unless self.new_record?
    nro = Vote.maximum(:order_number) || 0
    self.order_number = nro + 1
  end

  def invite(options)
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
    options = options.merge(inviter_name: name, token: self.public_token)
    VoteMailer.with(options: options).invite.deliver_now
  end

  def confirm!
    self.email_confirmed = Time.now
    self.save
  end

  # deprecated
  def self.duplicate_confirm_hash?(token)
    !!Vote.where(secret_confirm_hash: token).first
  end

  def encoded_payload
    return nil if self.new_record?
    payload = {
      vote_id: id,
      exp: (Time.now + 1.week).to_i # This sets the expiration time
    }
    JWT.encode(payload, ENV["UNITE_SECRET_KEY"], "HS256")
  end

  def private_token
    self.secret_token
  end

  def public_token
    self.md5_secret_token
  end

  # public: Returns an array of roles
  #
  # Roles are stored in vote as a space separated string.
  #
  # Returns an array of symbols.
  def roles
    return [] if self.role.blank?
    return self.role.split(" ").filter(&:present?).map(&:to_sym)
  end

  def admin?
    roles.include?(:admin)
  end

  private

  def make_public_token token
    Digest::MD5.hexdigest(token)
  end

  def make_private_token
    SecureRandom.hex(4) + Time.now.to_i.to_s[-4,4]
  end

  def set_private_token
    self.secret_token = make_private_token
  end

  def set_public_token
    raise "secret_token is nil" if secret_token.nil?
    self.md5_secret_token = make_public_token(secret_token)
  end

end
