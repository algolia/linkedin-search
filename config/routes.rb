LinkedinSearch::Application.routes.draw do
  get "/auth/:provider/callback" => "sessions#create"
  delete "/signout" => "sessions#destroy", as: :signout
  get '/demo', as: :demo, controller: 'welcome', action: 'demo'
  root "welcome#new"
end
