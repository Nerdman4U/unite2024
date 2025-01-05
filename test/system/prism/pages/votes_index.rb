class Pages::VotesIndex < SitePrism::Page
  set_url '/en/votes'
  section :header, Sections::Header, '.header'
end
