require "ostruct"

class Vote < ApplicationRecord
  # include Humanizer
  # require_human_on :create, :unless => :bypass_humanizer
  attr_accessor :bypass_humanizer
  attr_reader :ago

  validates :name, presence: true
  validates :country, presence: true
  validates :email, confirmation: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :email_confirmation, presence: true
  validates :ip, presence: true
  validates_format_of :ip, :with => /\A(\d{1,3}\.){3}\d{1,3}\z/
  validate :validate_country_code

  after_initialize :strip_email
  after_initialize :downcase_country_code
  before_save :add_secret_token
  before_save :add_vote_count

  has_many :votes, foreign_key: :vote_id
  has_many :comments, foreign_key: :vote_id
  #belongs_to :vote, counter_cache: true


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
    self.email_confirmation.strip! if email_confirmation
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
    vote_count = VoteCount.add_vote(self)
    self.order_number = VoteCount.total
  end

  # We do not allow duplicate tokens, lets be sure there is no equal
  # token already in database.
  def add_secret_token
    while token = SecureRandom.hex(64) do
      if Vote.where(secret_token: token).blank?
        require 'digest/md5'
        digest = Digest::MD5.hexdigest(token)
        self.secret_token = token
        self.md5_secret_token = digest
        break
      end
    end
  end

  def email_invite options
    return unless options[:name]
    return unless options[:email]
    return unless options[:language]
    options = options.merge(inviter_name: name, token: md5_secret_token)
    VoteMailer.email_invite(options).deliver_now
  end

end
