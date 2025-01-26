
# Preview all emails at http://localhost:3000/rails/mailers/vote_mailer
class VoteMailerPreview < ActionMailer::Preview
  def sign_up
    VoteMailer.with(vote: Vote.first).sign_up
  end

end
