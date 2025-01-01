# -*- coding: utf-8 -*-
require 'test_helper'

class LanguageTest < ActiveSupport::TestCase

  def setup
    I18n.locale = "en"
  end

  test 'should return correct locale for language name' do
    assert_equal Language.locale("arabic"), :ar
    assert_equal Language.locale("chinese"), :zh
    assert_equal Language.locale("english"), :en
    assert_equal Language.locale("french"), :fr
    assert_equal Language.locale("russian"), :ru
    assert_equal Language.locale("spanish"), :es
    assert_equal Language.locale("finnish"), :fi
    assert_equal Language.locale("german"), :de
    assert_equal Language.locale("swedish"), :se
  end

  test 'should return en for incorrect language name' do
    assert_equal Language.locale("foo"), :en
    assert_equal Language.locale(nil), :en
  end

  test 'should return sorted UN languages' do
    values = Language.sorted_un_languages
    assert_equal "Arabic", values[0][0]
    assert_equal :arabic, values[0][1]
    assert values.size, 9
  end

  test 'should translate with given locale' do
    assert_equal "Árabe", Language.translate("es", "Arabic")
    assert_equal "Árabe", Language.translate(:es, "Arabic")
    assert_equal "Arabic", Language.translate(:en, "Arabic")
    assert_raise ArgumentError do
      Language.translate("foo")
    end
    assert_raise ArgumentError do
      Language.translate
    end
  end

  test "should return a list of locales" do
    assert_equal Language.locales_list, ["ar", "de", "en", "es", "fi", "fr", "ru", "se", "zh"]
  end
end
