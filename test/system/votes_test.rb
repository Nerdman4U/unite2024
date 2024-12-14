require "application_system_test_case"

class VotesTest < ApplicationSystemTestCase
  test "Voting" do
    visit new_vote_url

    assert_selector "h1", text: "Support".upcase

    fill_in "vote_name", with: "Joni"
    fill_in "vote_email", with: "info@jonitoyryla.eu"
    fill_in "vote_email_repeat", with: "info@jonitoyryla.eu"
    select "Finland", from: "vote_country"

    click_on "Send"

    assert_selector "h1", text: "Waiting...".upcase
    assert_selector ".alert-info", text: "Your vote is added but email is not yet confirmed. Please check your email.".upcase
  end
end
