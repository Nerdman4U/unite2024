class Sections::Footer < SitePrism::Section
  element :login_link, 'a.login'
  element :logout_link, 'a.logout'
  element :vote_link, 'a.my-vote'
end
