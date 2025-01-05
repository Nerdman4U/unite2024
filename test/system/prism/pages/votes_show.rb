class Pages::VotesShow < SitePrism::Page
  set_url '/votes{/token}'
  section :header, Sections::Header, '.header'
end
