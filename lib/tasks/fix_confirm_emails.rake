namespace :fix do
  desc "Set confirmed flag true to current emails"
  task confirm_emails: :environment do
    Vote.where(spam: false, email_confirmed: false).each do |vote|
      vote.email_confirmed = Time.now
      unless vote.valid?
        puts "#{vote.email} not valid! #{vote.errors.full_messages}"
      end
      vote.save
      puts "#{vote.email} set confirmed"
    end
  end
end
