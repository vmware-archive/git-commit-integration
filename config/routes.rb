Rails.application.routes.draw do
  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
    }

  devise_scope :user do
    get 'sign_in', to: redirect('/users/auth/github'), as: :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', as: :destroy_user_session
  end

  authenticate :user do
    resources :repos
  end

  root 'home#show'
end
