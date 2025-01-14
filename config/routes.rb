Rails.application.routes.draw do
  root to: redirect("/en")

  get "votes/recently_added" => "votes#recently_added", as: :recently_added_votes
  get "votes/add_parent" => "votes#add_parent", as: :add_parent_vote
  post "votes/invite" => "votes#invite", as: :invite
  delete "tokens" => "tokens#destroy", as: :logout
  get "up" => "rails/health#show", as: :rails_health_check

  scope "/:locale", defaults: { locale: "en" }, constraints: lambda { |req| req.params[:locale].in? Language::UI.locales.map(&:to_s) } do
    root "welcome#index", as: :locale_root
    get "appeal" => "welcome#appeal", as: :appeal
    get "why_vote" => "welcome#why_vote", as: :why_vote
    get "initiative" => "welcome#initiative", as: :initiative
    resources :votes, only: [ :new, :index ]
    resources :votes, only: [ :show ], as: :vote, constraints: { token: /[^\/]+/ }, param: "token"
    resources :comments, only: [ :new, :show, :index ], constraints: { id: /\d+/ }
    resource :token, only: [ :new ]

    get "votes/waiting/:token" => "votes#waiting", as: :waiting
    get "votes/confirm/:token" => "votes#confirm", as: :confirm, constraints: { token: /[^\/]+/ }
    get "material" => "welcome#material", as: :material
  end

  post "comments" => "comments#create", as: "create_comment"
  post "votes" => "votes#create", as: "create_vote"
  post "tokens" => "tokens#create", as: "create_token"
  resolve("Token") { :token }

  draw(:admin)

  # Wrong locale redirects back to locale_root with default locale.
  get "/*anything", to: redirect("/en")

end
