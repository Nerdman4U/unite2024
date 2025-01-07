class Pages::TokensNew < Pages::Base
  set_url '/en/token/new'
  element :email, 'form#TokenForm input[name=email]'
  element :submit, 'form#TokenForm input[name=commit]'
end
