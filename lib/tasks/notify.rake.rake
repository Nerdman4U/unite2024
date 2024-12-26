namespace :notify do
  desc "Print vote info"
  task print: :environment do
    uas = UaSetting.instance
    votes = uas.votes_after_notify
    votes_needed = Rails.configuration.x.votes_in_notify_email.to_i - votes.count
    total = Vote.unspam.confirmed.count

    message = <<~MSG
    Last notify email has been sent at #{uas.sent_at}.
    After that, #{votes.count} votes has been added.
    Next email is sent when #{votes_needed} more votes is added.

    Total amount of votes in database is...
    - Vote.count: #{Vote.count}.
    - VoteCount.total: #{VoteCount.total}.

    VoteCount.total is the total amount of votes in all countries
    and is cached to redis.

    MSG

    puts message
  end
end
