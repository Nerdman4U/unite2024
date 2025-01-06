require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  test "should redirect to new vote if trying to comment without authorization" do
    visit new_comment_url
    assert_selector "h1", text: "Support".upcase


    #find("#language_arabic").click
  end

  test "should create comment" do
    vote = votes("vote_1")
    visit vote_path(token: vote.encoded_payload)
    assert_selector "h1", text: "Thank you".upcase

    visit new_comment_url
    assert_selector "h1", text: "Leave a comment".upcase

    within(".unitethearmies-form") do
      first(".language_container").click
      first(".theme_container").click
      fill_in "comment_body", with: "test comment"
      click_on "Send"
    end

    assert_selector "h1", text: "Thank you".upcase
  end
end
