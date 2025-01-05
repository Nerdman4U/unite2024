class Sections::FlashContainer < SitePrism::Section
  element :success, '.alert-success'
  element :warning, '.alert-warning'
  element :danger, '.alert-danger'
  element :info, '.alert-info'
end
