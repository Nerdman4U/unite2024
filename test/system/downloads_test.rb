require "application_system_test_case"

class DownloadsTest < ApplicationSystemTestCase
  # TODO
  # Results from clicks are not yet tested because i do not currently exactly know how to test them. Pdf-files are loaded from the server slower and test probably is done before file is loaded.
  # https://dev.to/coorasse/test-downloaded-files-with-rspec-and-system-tests-55mn
  test "visiting the index" do
    visit material_url locale: :en
    assert_selector "h1", text: "download".upcase
    click_on "guide_to_gathering"

    visit material_url locale: :en
    click_on "pamphlet"

    visit material_url locale: :en
    click_on "poster"

    visit material_url locale: :en
    click_on "signature_collection"
  end
end
