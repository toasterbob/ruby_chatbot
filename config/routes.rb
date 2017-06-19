
Rails.application.routes.draw do
  mount Facebook::Messenger::Server, at: "bot"

  root to: "cats#index"
  resources :cats, only: [:index, :create, :show]

end
