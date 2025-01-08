# -*- coding: utf-8 -*-
require 'test_helper'

class LanguageTest < ActiveSupport::TestCase

  def setup
    I18n.locale = "en"
  end

  test "should return a list of locales for UI" do
    assert_equal Language::UI.locales, ["ar", "de", "en", "es", "fi", "fr", "ru", "sv", "zh"]
  end

  test "should return a list of UN locales" do
    assert_equal Language::UN.locales, ["ar", "zh", "en", "fr", "ru", "es"]
  end

  test "should return a list of locale identifiers for UI" do
    assert Language::UI.identifiers.include? :arabic
    assert Language::UI.identifiers.include? :german
    assert Language::UI.identifiers.include? :english
    assert Language::UI.identifiers.include? :spanish
    assert Language::UI.identifiers.include? :finnish
    assert Language::UI.identifiers.include? :french
    assert Language::UI.identifiers.include? :russian
    assert Language::UI.identifiers.include? :swedish
    assert Language::UI.identifiers.include? :chinese
  end

  test "should return a list of locale identifiers for UN" do
    assert Language::UN.identifiers.include? :arabic
    assert !(Language::UN.identifiers.include? :german)
    assert Language::UN.identifiers.include? :english
    assert Language::UN.identifiers.include? :spanish
    assert !(Language::UN.identifiers.include? :finnish)
    assert Language::UN.identifiers.include? :french
    assert Language::UN.identifiers.include? :russian
    assert !(Language::UN.identifiers.include? :swedish)
    assert Language::UN.identifiers.include? :chinese
  end

  test "should return a list of language names for UI" do
    names = Language::UI.names
    assert names.include?("Arabic")
    assert names.include?("German")
    assert names.include?("English")
    assert names.include?("Spanish")
    assert names.include?("Finnish")
    assert names.include?("French")
    assert names.include?("Russian")
    assert names.include?("Swedish")
    assert names.include?("Chinese")
  end

  test "should return a list of language names of UN" do
    names = Language::UN.names
    assert names.include?("Arabic")
    assert !(names.include?("German"))
    assert names.include?("English")
    assert names.include?("Spanish")
    assert !(names.include?("Finnish"))
    assert names.include?("French")
    assert names.include?("Russian")
    assert !(names.include?("Swedish"))
    assert names.include?("Chinese")
  end

  test 'should return correct locale for identifier' do
    assert_equal Language::UI.locale(:arabic), :ar
    assert_equal Language::UI.locale(:chinese), :zh
    assert_equal Language::UI.locale(:english), :en
    assert_equal Language::UI.locale(:french), :fr
    assert_equal Language::UI.locale(:russian), :ru
    assert_equal Language::UI.locale(:spanish), :es
    assert_equal Language::UI.locale(:finnish), :fi
    assert_equal Language::UI.locale(:german), :de
    assert_equal Language::UI.locale(:swedish), :sv
  end

  test "should return correct identifier for locale" do
    assert_equal Language::UI.identifier(:ar), :arabic
    assert_equal Language::UI.identifier(:zh), :chinese
    assert_equal Language::UI.identifier(:en), :english
    assert_equal Language::UI.identifier(:fr), :french
    assert_equal Language::UI.identifier(:ru), :russian
    assert_equal Language::UI.identifier(:es), :spanish
    assert_equal Language::UI.identifier(:fi), :finnish
    assert_equal Language::UI.identifier(:de), :german
    assert_equal Language::UI.identifier(:sv), :swedish
  end

  test "should validate locale" do
    assert Language::UI.valid?(:ar)
    assert Language::UI.valid?(:zh)
    assert !(Language::UI.valid? nil)
    assert !(Language::UI.valid?(""))
    assert !(Language::UI.valid?(:foo))

    assert Language::UN.valid?(:ar)
    assert !(Language::UN.valid?(:sv))
    assert !(Language::UN.valid?(:fi))
    assert !(Language::UN.valid?(:de))
  end

  test "should validate identifier" do
    assert Language::UI.valid_identifier?(:arabic)
    assert Language::UI.valid_identifier?(:chinese)
    assert !(Language::UI.valid_identifier? nil)
    assert !(Language::UI.valid_identifier?(""))
    assert !(Language::UI.valid_identifier?(:foo))
  end

  test "should validate name" do
    assert Language::UI.valid_name?(:Arabic)
    assert Language::UI.valid_name?("Arabic")
    assert Language::UI.valid_name?(:Chinese)
    assert Language::UI.valid_name?(:English)
    assert Language::UI.valid_name?(:Spanish)
    assert Language::UI.valid_name?(:Finnish)
    assert Language::UI.valid_name?(:French)
    assert Language::UI.valid_name?(:Russian)
    assert Language::UI.valid_name?(:Swedish)
    assert Language::UI.valid_name?(:Chinese)

    assert !(Language::UI.valid_name? nil)
    assert !(Language::UI.valid_name?(""))
    assert !(Language::UI.valid_name?(:foo))
  end

  test 'should return en for incorrect language name' do
    assert_equal Language::UI.locale("foo"), :en
    assert_equal Language::UI.locale(nil), :en
  end

  test 'should return sorted UN languages' do
    values = Language::UN.sorted_languages
    assert_equal "Arabic", values[0][0]
    assert_equal :arabic, values[0][1]
    assert_equal values.size, 6
  end

  test 'should return sorted UI languages' do
    values = Language::UI.sorted_languages
    assert_equal "Arabic", values[0][0]
    assert_equal :arabic, values[0][1]
    assert_equal values.size, 9
  end

  test 'should translate with given locale' do
    assert_equal "Englanti", Language::UI.translate(:fi, "English")
    assert_raise ArgumentError do
      Language::UN.translate(:fi, "English")
    end
    assert_equal "Árabe", Language::UI.translate("es", "Arabic")
    assert_equal "Árabe", Language::UI.translate(:es, "Arabic")
    assert_equal "Arabic", Language::UI.translate(:en, "Arabic")
    assert_raise ArgumentError do
      Language::UI.translate("foo")
      Language::UN.translate("foo")
    end
    assert_raise ArgumentError do
      Language::UI.translate
      Language::UN.translate
    end
    assert_raise NoMethodError do
      Language.translate(nil) # no method
    end
  end
end
