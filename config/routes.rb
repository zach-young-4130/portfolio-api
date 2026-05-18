Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resource :session, only: %i[create destroy show] do
        post "google", action: :create_google
      end
      resources :projects, only: %i[index show create update destroy]
      resources :faq_items, only: %i[index create update destroy]
      resources :community_items, only: %i[index create update destroy]
      resources :contact_messages, only: %i[index create update]
    end
  end
end
