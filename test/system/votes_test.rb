require "application_system_test_case"

class VotesTest < ApplicationSystemTestCase
  setup do
    I18n.locale = :en
  end

  test "Voting" do
    visit new_vote_url

    assert_selector "h1", text: "Support".upcase

    fill_in "vote_name", with: "Joni"
    fill_in "vote_email", with: "info@jonitoyryla.eu"
    fill_in "vote_email_repeat", with: "info@jonitoyryla.eu"
    select "Finland", from: "vote_country"

    click_on "Send"

    assert_selector "h1", text: "confirm email sent!".upcase
    assert_selector ".alert-info", text: "Your vote is added but email is not yet confirmed. Please check your email.".upcase
  end

  test "Confirmation" do
    vote = votes("vote_1")
    vote.email_confirmed = nil
    vote.save

    visit confirm_url(token: vote.encoded_payload)

    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase
    assert_selector ".alert-success", text: "Your email has been confirmed".upcase
  end

  test "Should invite" do
    vote = votes("vote_1")
    token = vote.encoded_payload

    visit vote_url(token: token)
    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase

    select "English", from: "language"
    fill_in "name", with: "Kutsutaan Kari"
    fill_in "email", with: "kari@example.com"
    fill_in "email_repeat", with: "kari@example.com"
    click_on "Send"

    assert_selector ".alert-success", text: "Invitation has been sent, thank you!".upcase
  end

  test "Should not invite if email repeat does not match" do
    vote = votes("vote_1")
    token = vote.encoded_payload

    visit vote_url(token: token)
    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase

    select "English", from: "language"
    fill_in "name", with: "Kutsutaan Kari"
    fill_in "email", with: "kari@example.com"
    fill_in "email_repeat", with: "kari@example.com2"
    click_on "Send"

    assert_selector "h1", text: "Save the Planet".upcase
    assert_selector ".alert-warning", text: "Emails do not match".upcase
  end

  test "Should not invite if vote is not found" do
    vote = votes("vote_1")
    token = vote.encoded_payload

    visit vote_url(token: token)
    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase

    vote.destroy

    select "English", from: "language"
    fill_in "name", with: "Kutsutaan Kari"
    fill_in "email", with: "kari@example.com"
    fill_in "email_repeat", with: "kari@example.com2"
    click_on "Send"

    assert_selector "h1", text: "Save the Planet".upcase
    assert_selector ".alert-warning", text: "there was an error".upcase
  end

end
