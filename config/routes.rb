require 'sidekiq/web'

Rails.application.routes.draw do
  resources :home_infos
  resources :hire_mes
  resources :sites
  get 'tags/:tag', to: 'blog#index', as: :tag
  namespace :blog do
  end
  resource :lead
  resources :wallpapers
  get 'wallpapers/index'
  resources :photos
  # namespace :broadcaster do
  #   get 'dashboard/index'
  # end

  namespace :broadcaster do
    resources :dashboard, only: [:index, :show]
    resources :avatars
    resources :themes, shallow: true do
      resources :outlines
      resources :videos
      resources :audios
      resources :social_entries
      resources :theme_avatars
    end
  end
  resources :press_kits, only: [:show]
  resources :first_times, only: [:show]

  resources :backstage, only: [:index]
  namespace :backstage do
    # resources :agenda # agendum
    resources :agenda
    resources :blog_hub
    resources :books
    # namespace :blog do
    #   resources :entries
    #   resources :recommendations
    #   resources :articles
    # end
    resources :meetups
    resources :merchandise_links
    resources :messages
    resources :publisher_accounts
    resources :settings, only: [:index]
    resources :site, shallow: true do
      resources :biography
      resources :first_time
      resources :get_in_contact_contents
      resources :hire_me
      resources :home_info
      resources :press_kit, shallow: true do
        resources :press_kit_entries
        resources :press_kit_links
        resources :press_kit_photos    
      end
    end


    resources :media_appearances
    resources :meetups
    resources :merchandise_links
    # resources :tasks
    resources :wallpapers
  end

  get 'services/index'
  resources :books, only: [:index]
  resources :media_appearances
  resources :podcasts, only: [:index, :show]
  resources :wallpapers, only: [:index, :show]

  resources :blog, only: [:index]
  namespace :blog do
    resources :entries
    resources :recommendations
    # root to: "entries#index"
    resources :articles
  end

  namespace :admin do
    resources :users
    resources :announcements
    resources :biographies
    resources :books
    resources :first_times
    resources :first_time_entries
    resources :get_in_contact_contents
    resources :meetups
    resources :merchandise_links
    resources :notifications
    resources :press_kits
    resources :press_kit_entries
    resources :press_kit_links
    resources :press_kit_photos
    resources :publisher_accts

    # resources :leads


    root to: "users#index"
  end

  ## home links
  get '/privacy', to: 'home#privacy'
  get '/podcast', to: 'podcasts#index'
  get '/events', to: 'meetups#index'
  get '/media-appearances', to: 'media_appearances#index'
  get '/terms', to: 'home#terms'
  get '/biography', to: 'home#biography'
  get '/first-time-here', to: 'first_times#show'
  get '/hire-me', to: 'home#hire_me'
  get '/get-in-touch-with-me', to: 'leads#new'
  get '/press-kit', to: 'press_kits#show'

  ## backstage links
  get '/backstage/blog', to: 'backstage#blog'
  get '/backstage/site_settings', to: 'backstage#site_settings'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end


  resources :notifications, only: [:index]
  resources :backstage, only: [:index]
  resources :announcements, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
