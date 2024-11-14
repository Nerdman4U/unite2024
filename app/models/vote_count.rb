class VoteCount < ApplicationRecord
  validates :country, presence: true
  validates :count, numericality: { greater_than: 0 }
  validate :validate_country_code

  after_initialize :downcase_country_name

  def downcase_country_name
    return unless country
    self.country.downcase!
  end

  def validate_country_code
    if country.blank? || Country.codes.index(country.upcase).nil?
      errors.add(:country, "is not valid")
    end
  end

  def self.add_vote vote
    vote_count = where(country: vote.country).first ||
      new(country: vote.country.downcase, count: 1)
    vote_count.count += 1 unless vote_count.new_record?
    vote_count.save

    VoteCount.clear_values
    VoteCount.total # calculate new total number of votes

    vote_count
  end

  def self.target_vote_count
    100000
  end

  def self.clear_values
    @@total = nil
    @@max = nil
  end

  # Count of all votes in all countries
  #
  # CACHE !!!
  def self.total
    @@total ||= all.map(&:count).reduce(:+)
  end

  # Vote count of most votes country
  def self.max
    @@max ||= all.map(&:count).max
  end

  # Return percent of all votes of the most voted country.
  # For example: if county x has 100 votes of the total 1000 and it is
  # most votes country, this value is 10.
  #
  # return: a float value to enable relative values less than percent
  def max_percent_of_total
    (self.class.max.to_f/self.class.total*100)
  end

  # return: a float value to enable relative values less than percent
  def percent_of_total
    VoteCount.total.blank? ? 0 : ((count.to_f / VoteCount.total)*100)
  end

  # Calculate width of the diagram
  #
  # Max percent of all vote_counts have 100% width. Calculate other
  # widths based on this.
  #
  # max: 5
  # current: 2
  # width: 5.0/2*100
  #
  # params:
  # max: maximum relative percent of all votes, for example: if there
  # are 1000 votes total and most votes is in country X, 100 votes then
  # maximum percent is 10 and this value is shown at the top of the view
  # and has 100% width.
  # current: current country percent of all votes.
  def calculate_diagram_width max, current
    return 0 if current <= 0
    (current.to_f/max.to_f * 1000).to_i / 10.0
  end

  def diagram_width
    calculate_diagram_width(max_percent_of_total, percent_of_total)
  end


end
