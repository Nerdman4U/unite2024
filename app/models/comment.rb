class Comment < ApplicationRecord
  # include Humanizer
  attr_accessor :bypass_humanizer
  # require_human_on :create, :unless => :bypass_humanizer

  # validates :name, presence: true
  validates :language, presence: true
  # validates :email, confirmation: true
  # validates :email, presence: true, uniqueness: true, email: true
  # validates :email_confirmation, presence: true
  validates :ip, presence: true
  validates_format_of :ip, with: /\A(\d{1,3}\.){3}\d{1,3}\z/
  validates :vote, presence: true
  validate :validate_language_literal
  validate :validate_theme

  after_initialize :downcase_theme

  belongs_to :vote

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

  def validate_language_literal
    if language.blank?
      return errors.add(:language, message: "You need to select language before posting a comment.")
    end
    unless Language.valid_un_language? language
      errors.add(:language, "is not valid")
    end
  end

  def email_comment
    VoteMailer.with(comment: self).new_comment.deliver_now
  end

  def language_name
    return nil if language.blank?
    return nil unless Language::LOCALES[language.to_sym]
    language.capitalize
  end


end
