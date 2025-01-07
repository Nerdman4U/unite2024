class Pages::VotesShow < Pages::Base
  set_url '/en/votes/{/token}'
  section :header, Sections::Header, '.header'
end
