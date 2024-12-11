namespace :fix do
  desc "fix vote counts"
  task vote_counts: :environment do
    votes = {}
    Vote.all.each do |vote|
      votes[vote.country] ||= 0
      votes[vote.country] += 1
    end

    # puts "votes: #{votes.inspect}"

    votes.each do |country, count|
      vote = VoteCount.where(country: country).first
      vote.count = count
      puts "vote: #{vote.country} #{vote.count}"
      vote.save
    end
  end
end
