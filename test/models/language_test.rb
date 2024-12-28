# -*- coding: utf-8 -*-
require 'test_helper'

class LanguageTest < ActiveSupport::TestCase

  def setup
    I18n.locale = "en"
  end

  test 'should return translated UN languages' do
    I18n.locale = "es"
    values = Language.un_languages
    correct_values = [
      ["Árabe", :arabic],
      ["Chino", :chinese],
      ["Español", :spanish],
      ["Francés", :french],
      ["Inglés", :english],
      ["Ruso", :russian]
    ]

    correct_values.each do |correct_value|
      assert_equal correct_value[0], values[correct_value[1]]
    end
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
    assert_equal "Arabic", values[0][1]
    assert values.size, 9
  end

end
