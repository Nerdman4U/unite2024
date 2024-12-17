module VotesHelper
  def waiting_time_left
    confirm_email_sent = session[:confirm_email_sent].try(:to_time)
    # puts "Waiting time left confirm_email_sent: #{confirm_email_sent} #{confirm_email_sent.blank?}"
    if !confirm_email_sent || Time.now - confirm_email_sent > 5.minutes
      # puts "Waiting_time_left, no confirm_email_sent: #{confirm_email_sent.inspect}"
      session[:confirm_email_sent] = nil
      return nil
    end

    wait_left = (5.minutes - (Time.now - confirm_email_sent).to_f) / 60
    wait_left_minutes = wait_left.to_i
    wait_left_seconds = (((wait_left - wait_left_minutes).to_f) * 60).round

    # puts "VotesHelper.waiting_time_left: session: #{session[:confirm_email_sent].inspect}"
    # puts "VotesHelper.waiting_time_left: wait_left: #{wait_left}, wait_left_minutes: #{wait_left_minutes}, wait_left_seconds: #{wait_left_seconds}"

    { min: wait_left_minutes, sec: wait_left_seconds }
  end
end
