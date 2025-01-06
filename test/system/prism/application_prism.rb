class ApplicationPrism
  def welcome_index
    Pages::WelcomeIndex.new
  end
  def welcome_appeal
    Pages::WelcomeAppeal.new
  end

  def votes_index
    Pages::VotesIndex.new
  end
  def votes_show
    Pages::VotesShow.new
  end
  def votes_new
    Pages::VotesNew.new
  end

  def tokens_new
    Pages::TokensNew.new
  end

end
