
Rails.application.routes.draw do
  mount Facebook::Messenger::Server, at: "bot"


  resources :cats, only: [:index, :create, :show]

end
