# -*- coding: utf-8 -*-
require 'test_helper'

class LanguageTest < ActiveSupport::TestCase

  test 'should return translated select options in sorted order by language' do
    I18n.locale = "es"
    values = Language.translated_select_options
    correct_values = [
                      ["Árabe","arabic"],
                      ["Chino","chinese"],
                      ["Español", "spanish"],
                      ["Francés","french"],
                      ["Árabe","english"],
                      ["Ruso","russian"]
                     ]

    # Find each correct value item from values.
    correct_values.each do |value|
      assert !values.index(value).try(:nil?), value
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

end
