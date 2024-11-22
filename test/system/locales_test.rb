require "application_system_test_case"

class LocalesTest < ApplicationSystemTestCase
  test "root url headers" do
    visit locale_root_path(locale: :ar)
    assert_selector "h1", text: "أنقذ الكوكب"

    visit locale_root_path(locale: :zh)
    assert_selector "h1", text: "拯救地球"

    visit locale_root_path(locale: :en)
    assert_selector "h1", text: "Save the planet".upcase

    visit locale_root_path(locale: :fr)
    assert_selector "h1", text: "Sauvez la planète".upcase

    visit locale_root_path(locale: :ru)
    assert_selector "h1", text: "Спасите планету".upcase

    visit locale_root_path(locale: :es)
    assert_selector "h1", text: "!Salvar el planeta!".upcase

    visit locale_root_path(locale: :de)
    assert_selector "h1", text: "Den Planeten retten".upcase

    visit locale_root_path(locale: :se)
    assert_selector "h1", text: "Rädda planeten".upcase

    visit locale_root_path(locale: :fi)
    assert_selector "h1", text: "pelasta maailma".upcase
  end

  test "locale links at header are not https" do
    visit locale_root_path(locale: :en)

    click_link "Arabic"

    assert_not current_url.match? "https"
  end

end
