class Country < ApplicationRecord

  def self.names
    from_disc.map { |x| x[1] }
  end

  def self.codes
    from_disc.map { |x| x[0] }
  end

  def self.to_h
    from_disk.to_h
  end

  # Array for select_tag helper
  def self.for_select
    from_disc.map {|x| x.reverse}
  end

  def self.code_to_name code
    from_disc.to_h[code.upcase]
  end

  def self.from_disc
    Rails.cache.fetch("countries_from_disk") do
      fp = open(File.join(Rails.root, "vendor/data/country-list-iso-codes.txt"))
      data = fp.readlines
      fp.close
      data.map do |i|
        i.strip!
        i.split(":") rescue nil
      end.compact
    end
  end
end
