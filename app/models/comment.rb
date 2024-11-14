class Comment < ApplicationRecord
  #include Humanizer
  attr_accessor :bypass_humanizer
  #require_human_on :create, :unless => :bypass_humanizer

  #validates :name, presence: true
  validates :language, presence: true
  #validates :email, confirmation: true
  #validates :email, presence: true, uniqueness: true, email: true
  #validates :email_confirmation, presence: true
  validates :ip, presence: true
  validates_format_of :ip, :with => /\A(\d{1,3}\.){3}\d{1,3}\z/
  validates :vote, presence: true
  validate :validate_language_literal
  validate :validate_theme

  after_initialize :downcase_theme

  belongs_to :vote

  def downcase_theme
    self.theme.downcase! unless theme.blank?
  end

  def validate_theme
    themes = %w(administration water climate plastic-waste protected-areas)
    if themes.index(theme).nil?
      errors.add(:theme, "is not valid")
    end
  end

  def validate_language_literal
    if Language.names.index(language).nil?
      errors.add(:language, "is not valid")
    end
  end

  def email_comment
    VoteMailer.new_comment(self).deliver_now
  end

  def self.translated_themes
    {
      "administration" => _("Administration"),
      "water" => _("Water"),
      "climate" => _("Climate"),
      "plastic-waste" => _("Plastic Waste"),
      "protected-areas" => _("Protected Areas")
    }
  end
end
