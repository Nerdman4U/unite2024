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

    visit locale_root_path(locale: :sv)
    assert_selector "h1", text: "Rädda planeten".upcase

    visit locale_root_path(locale: :fi)
    assert_selector "h1", text: "pelasta maailma".upcase
  end

  test "should have main navigation" do
    visit locale_root_path(locale: :en)
    assert_selector "header a", text: "باللغة العربية".upcase
    assert_selector "header a", text: "中文".upcase
    assert_selector "header a", text: "in English".upcase
    assert_selector "header a", text: "en francés".upcase
    assert_selector "header a", text: "в России".upcase
    assert_selector "header a", text: "en español".upcase
    assert_selector "header a", text: "suomeksi".upcase
    assert_selector "header a", text: "auf Deutsch".upcase
    assert_selector "header a", text: "på svenska".upcase
  end

  test "should have locale links at header http" do
    visit locale_root_path(locale: :en)

    click_link "in English"

    assert_not current_url.match? "https"
  end

end
