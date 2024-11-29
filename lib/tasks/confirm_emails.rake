namespace :fix do
  desc "Set confirmed flag true to current emails"
  task set_confirmed: :environment do
    Vote.all.each do |vote|
      vote.email_confirmed = Time.now
      if vote.save
        puts "#{vote.email} confirmed"
      else
        puts "#{vote.email} not confirmed, #{vote.errors.full_messages}"
      end
    end
  end
end
