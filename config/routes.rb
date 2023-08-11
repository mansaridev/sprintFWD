Rails.application.routes.draw do
  root 'teams#index'
  resources :teams do
    resources :members, shallow: true do
      get :edit_team
    end
  end
  resources :projects do
    member do
      post :add_member
    end
  end

  get '/members', to: 'members#members'
end
