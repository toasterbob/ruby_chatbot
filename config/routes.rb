
Rails.application.routes.draw do
  mount Facebook::Messenger::Server, at: "bot"

  namespace :api do
    resources :cats, only: [:index, :create, :show]
  end
end
