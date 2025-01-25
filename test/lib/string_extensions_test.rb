require [Dir.pwd, "lib/string_extensions"].join("/")
using StringExtensions

class StringExtensionsTest < ActiveSupport::TestCase
  test "unite_escape" do
    assert_equal "a", "a".unite_escape
    assert_equal "a", "a()".unite_escape
    assert_equal "a", "a/".unite_escape
    assert_equal "a", "\\a".unite_escape
  end

  test "emotify" do
    assert_equal "a:bi-emoji-smile:".emotify, "a<i class=\"bi bi-emoji-smile\"></i>"
    assert_equal "a".emotify, "a"
    assert_equal "a:".emotify, "a:"
    assert_equal ":a".emotify, ":a"
    assert_equal "a::".emotify, "a::"
  end

end