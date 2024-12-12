# -*- coding: utf-8 -*-

require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    I18n.locale = :en
  end

  test "should have correct locale" do
    assert_equal :en, I18n.locale
    assert_equal :en, I18n.default_locale
    assert_equal "en", FastGettext.locale
    assert_equal "en", FastGettext.default_locale
    get locale_root_url locale: :ru
    assert_equal I18n.locale, :ru
    assert_equal FastGettext.locale, "ru" # FastGettext converts locale as a symbol to string...
    assert_equal session[:locale], :ru
  end

  test "should not allow wrong locale" do
    get locale_root_url locale: "foobar"
    assert_equal I18n.locale, :en
    get root_url locale: "foobar"
    assert_equal I18n.locale, :en
  end
end
