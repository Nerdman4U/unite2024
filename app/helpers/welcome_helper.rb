module WelcomeHelper
  def link_to_vote
    token = "new_token"
    if vote_id = session[:current_vote_id]
      if vote = Vote.find_by_id(vote_id)
        token = vote.encoded_payload
      end
    end

    link_to vote_url(token: token), target: "_blank" do
      tag :span, class: "icon-twitter-with-circle medium"
    end
  end
end
