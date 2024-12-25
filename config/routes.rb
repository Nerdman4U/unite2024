Rails.application.routes.draw do
  root "welcome#index"

  get "votes/recently_added" => "votes#recently_added", as: :recently_added_votes

  post "votes/add_parent" => "votes#add_parent", as: :add_parent_vote
  post "votes/invite" => "votes#invite", as: :invite

  get "admin/:admin_hash" => "welcome#admin", as: :admin_index
  post "admin/:admin_hash" => "welcome#admin_upload", as: :admin_upload

  delete "tokens" => "tokens#destroy", as: :logout

  scope "(:locale)" do
    get "" => "welcome#index", as: :locale_root
    get "appeal" => "welcome#appeal", as: :appeal
    resources :votes, only: [ :new, :index, :create ]
    resources :comments, only: [ :new, :index, :create ]
    resources :tokens, only: [ :new, :create ]
    get "votes/waiting/:id" => "votes#waiting", as: :waiting
    get "votes/confirm/:token" => "votes#confirm", as: :confirm, constraints: { token: /[^\/]+/ }
    get "votes/:token" => "votes#show", as: :vote, constraints: { token: /[^\/]+/ }
    get "download" => "welcome#download", as: :download # only finnish
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
