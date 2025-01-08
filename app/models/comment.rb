class Comment < ApplicationRecord
  scope :unconfirmed, -> { where(confirmed_at: nil) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  validates :language, presence: true
  validates :ip, presence: true
  validates_format_of :ip, with: /\A(\d{1,3}\.){3}\d{1,3}\z/
  validates :vote, presence: true
  validate :validate_language_identifier
  validate :validate_theme

  after_initialize :downcase_theme

  belongs_to :vote

  before_save :slugify

  def downcase_theme
    self.theme.downcase! unless theme.blank?
  end

  def validate_theme
    if theme.blank?
      return errors.add(:theme, message: "You need to select a theme before posting a comment.")
    end
    themes = %w[administration water climate plastic-waste protected-areas]
    unless themes.any? { |t| t == theme }
      errors.add(:theme, "is not valid")
    end
  end

  def validate_language_identifier
    if language.blank?
      return errors.add(:language, message: "You need to select language before posting a comment.")
    end
    unless Language::UI.valid_identifier? language
      errors.add(:language, "is not valid")
    end
  end

  def email_comment
    VoteMailer.with(comment: self).new_comment.deliver_now
  end

  def language_name
    return nil if language.blank?
    return nil unless Language::UI.valid_identifier?(language.to_sym)
    language.capitalize
  end

  def slug
    body = self.body.unite_escape.downcase.split[0..10].filter(&:present?).join("-")
    result = [self.theme, body, self.id].join("-")
    result
  end

  def slugify
    self.slug = slug
  end

  def self.random_comment_for_language language
    return nil unless Language::UI.valid_identifier? language
    confirmed.where(language: language).sample
  end

  def name
    return "Anonymous" if self.anonymous
    return "Anonymous" unless self.vote
    self.vote.name
  end

end
