class Pages::CommentsNew < Pages::Base
  set_url '/en/comments/new'

  element :language_arabic, 'form#CommentForm div#language_arabic'
  element :language_chinese, 'form#CommentForm div#language_chinese'
  element :language_english, 'form#CommentForm div#language_english'
  element :language_french, 'form#CommentForm div#language_french'
  element :language_russian, 'form#CommentForm div#language_russian'
  element :language_spanish, 'form#CommentForm div#language_spanish'

  element :theme_administration , '.theme_administration'
  element :theme_water          , '.theme_water'
  element :theme_climate        , '.theme_climate'
  element :theme_plastic_waste  , '.theme_plastic-waste'
  element :theme_protected_areas, '.theme_protected-areas'

  element :comment_conclusion, 'form#CommentForm .comment_conclusion'
  element :comment_description, 'form#CommentForm .comment_description'
  element :comment_body, 'form#CommentForm textarea#comment_body'
  element :comment_anonymous, 'form#CommentForm input#comment_anonymous'
  element :comment_submit, 'form#CommentForm input[name=commit]'
end
