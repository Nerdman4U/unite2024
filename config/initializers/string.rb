# TODO:
# How to test?
# >> rails test test/initializers/string.rb
# Error:
# StringTest#test_unite_escape:
# NoMethodError: undefined method `unite_escape' for an instance of String
#     test/initializers/string_test.rb:3:in `block in <class:StringTest>'
class String
  # Allow unicode characters and ! -
  def unite_escape
    self.gsub(/[¤`~@#$%^&*()_|+=?;:'",.<>\{\}\[\]\\\/\]]/, '')
  end
end
