# public: Allow unicode characters and ! -
#
# TODO: nimihän pitäisi olla remove_special_characters tms.
#
# Returns a string without special characters.
module StringExtensions
  refine String do

    # Allow unicode characters and ! -
    def unite_escape
      self.gsub(/[¤`~@#$%^&*()_|+=?;:'",.<>\{\}\[\]\\\/\]]/, '')
    end

    def emotify
      # puts "emotify, self:#{self} match:#{self.match(/:.*?:/)}"
      if (self.match(/:.*?:/)).nil? then return self end
      if (self.match(/:.*?:/).to_s == "::") then return self end
      self.gsub(/:(.*?):/) { "<i class=\"bi #{$1}\"></i>" }
    end

  end
end

