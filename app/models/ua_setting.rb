class UaSetting < ApplicationRecord
  @@instance = nil

  def self.instance
    @@instance ||= first || new
  end

  # Send backup email when VoteCount.total is bigger than
  # UaSetting.vote_count + UaSetting.sent_count...
  #
  # By default send backup email always after 100 new votes. Pick votes
  # from database using UaSetting.sent_at timestamp (newer should be
  # sent).
  #
  # This method does not check if sending should happend, this must
  # happen in controller. This method only sets new values and sends
  # email.
  def send!
    begin
      my_time = Time.now
      my_count = VoteCount.total

      VoteMailer.vote_backup(my_time).deliver_now

      self.sent_at = my_time
      self.vote_count = my_count
      save
    rescue
      Rails.logger.error("Failed to send backup email: #{$!}")
    end
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
