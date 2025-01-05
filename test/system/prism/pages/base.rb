class Pages::Base < SitePrism::Page
  section :header, Sections::Header, '.header'
  section :footer, Sections::Footer, 'footer:first-of-type'
  section :flash, Sections::FlashContainer, '.flash_container'
end
