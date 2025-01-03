require "application_system_test_case"

class VotesTest < ApplicationSystemTestCase
  setup do
    I18n.locale = :en
  end

  #########################################################################3
  # New
  #########################################################################3

  test "should add new vote" do
    visit new_vote_url

    assert_selector "h1", text: "Support".upcase

    fill_in "vote_name", with: "Testi01"
    fill_in "vote_email", with: "testi01@unitethearmies.org"
    fill_in "vote_email_repeat", with: "testi01@unitethearmies.org"
    select "Finland", from: "vote_country"

    click_on "Send"

    assert_selector "h1", text: "confirm email sent".upcase
    assert page.all(".alert-info li", text: "Your vote is added but email is not yet confirmed. Please check your email.".upcase)
    # assert_selector ".alert-info", text: "Your vote is added but email is not yet confirmed. Please check your email.".upcase
  end

  test "should add new vote with parent" do
    vote = votes("vote_1")
    token = vote.md5_secret_token

    visit new_vote_path(parent_vote: vote.md5_secret_token)
    assert_selector "h1", text: "Support".upcase
    assert_equal page.find_by_id("parent_vote", visible: false).value, token

    fill_in "vote_name", with: "Testi01"
    fill_in "vote_email", with: "testi01@unitethearmies.org"
    fill_in "vote_email_repeat", with: "testi01@unitethearmies.org"
    select "Finland", from: "vote_country"

    click_on "Send"

    assert_selector "h1", text: "confirm email sent".upcase
    # assert_selector(".alert-info li", text: "Your vote is added but email is not yet confirmed. Please check your email.".upcase)
    assert page.all(".alert-info li", text: "Your vote is added but email is not yet confirmed. Please check your email.".upcase)
    assert vote.votes.size == 1
  end

  test "should add new vote without parent if parent is not confirmed" do
    vote = votes("vote_1")
    assert vote.votes.size == 0

    vote.email_confirmed = nil
    vote.save

    visit new_vote_path(parent_vote: vote.md5_secret_token)
    assert_selector "h1", text: "Support".upcase

    fill_in "vote_name", with: "Testi01"
    fill_in "vote_email", with: "testi01@unitethearmies.org"
    fill_in "vote_email_repeat", with: "testi01@unitethearmies.org"
    select "Finland", from: "vote_country"

    click_on "Send"

    assert_selector "h1", text: "confirm email sent".upcase
    assert page.all(".alert-info", text: "Your vote is added but email is not yet confirmed. Please check your email.".upcase)
    assert vote.votes.size == 0
  end

  #########################################################################3
  # Confirm
  #########################################################################3
  test "confirmation" do
    vote = votes("vote_1")
    vote.email_confirmed = nil
    vote.save

    visit confirm_url(token: vote.encoded_payload)

    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase
    assert page.all(".alert-success", text: "Your email has been confirmed".upcase)
  end

  #########################################################################3
  # Invite
  #########################################################################3
  test "should invite" do
    vote = votes("vote_1")
    token = vote.encoded_payload

    visit vote_url(token: token)
    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase

    select "English", from: "language"
    fill_in "name", with: "Kutsutaan Kari"
    fill_in "email", with: "kari@example.com"
    fill_in "email_repeat", with: "kari@example.com"
    click_on "Send"

    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase
    assert page.all(".alert-success", text: "Invitation has been sent, thank you!".upcase)
  end

  test "should not invite if email repeat does not match" do
    vote = votes("vote_1")
    token = vote.encoded_payload

    visit vote_url(token: token)
    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase

    select "English", from: "language"
    fill_in "name", with: "Kutsutaan Kari"
    fill_in "email", with: "kari@example.com"
    fill_in "email_repeat", with: "kari@example.com2"
    click_on "Send"

    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase
    assert page.all(".alert-warning", text: "Emails do not match".upcase)
  end

  test "should not invite if email is invalid but repeat is valid" do
    vote = votes("vote_1")
    token = vote.encoded_payload

    visit vote_url(token: token)
    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase

    select "English", from: "language"
    fill_in "name", with: "Kutsutaan Kari"
    fill_in "email", with: "kari"
    fill_in "email_repeat", with: "kari"
    click_on "Send"

    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase
    assert page.all(".alert-warning", text: "Email is not valid".upcase)
  end

  test "should not invite if vote is not found" do
    vote = votes("vote_1")
    token = vote.encoded_payload

    visit vote_url(token: token)
    assert_selector "h1", text: "Thank you for your support #{vote.name}".upcase

    vote.destroy

    select "English", from: "language"
    fill_in "name", with: "Kutsutaan Kari"
    fill_in "email", with: "kari@example.com"
    fill_in "email_repeat", with: "kari@example.com"
    click_on "Send"

    assert_selector "h1", text: "Save the Planet".upcase
    assert page.all(".alert-warning", text: "there was an error".upcase)
  end

end
