# Preview all emails at http://localhost:3000/rails/mailers/vote_mailer
class VoteMailerPreview < ActionMailer::Preview
  def sign_up
    VoteMailer.with(vote: Vote.first).sign_up
  end
  def token
    VoteMailer.with(vote: Vote.first, token: "testitoken").token
  end

  def new_comment
    VoteMailer.with(comment: Comment.first).new_comment
  end

  def invite
    VoteMailer.with(options: {inviter_name: "Inv the Inviter", name: "Matti Meikäläinen", email: "m@m.com.test", language: "fi", token: "testitoken"}).invite
  end

  def emails_to_admins
    VoteMailer.with(votes: Vote.last(5)).emails_to_admins
  end

  def confirmation
    VoteMailer.with(vote: Vote.first, url: "http://localhost:3000", confirm_url: "http://localhost:3000/confirm").confirmation
  end

end
