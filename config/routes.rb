Colegio::Application.routes.draw do
  devise_for :members
  root to: 'home#index'

  match '/testing' => 'members#testing'
  match '/calendario/dia/:event_date' => 'calendar#show', :as => 'day_events'
  match '/eventos/categoria/:event_type' => 'events#index', as: 'category_events'
  match '/event_dates/:event_type' => 'event_dates#index'
  match '/colegio/:page_id' => 'static#show', as: 'colege'
  match '/filiales/:sub_type' => 'events#index', as: 'sub_category_events'
  match '/modulos/:sub_type' => 'events#index', as: 'sub_category_events'

  match '/industria' => 'static#show', page_id: 'industria', as: 'industry'
  match '/contacto' => 'static#show', page_id: 'contacto', as: 'contact'
  match '/filiales' => 'static#show', page_id: 'indice-filiales', as: 'filiales'
  match '/modulos' => 'static#show', page_id: 'indice-modulos', as: 'modulos'
  match '/sugerencias' => 'contact#new', as: 'suggestions'
  match 'new_suggestion' => 'contact#create', as: 'new_suggestion', via: :post
  match 'public_contact' => 'contact#public_contact', :as => 'public_contact', :via => :post

  resources :events
  resources :members do
    get '(letra/:letter)/page/:page', :action => :index, :on => :collection
    get 'letra/:letter', action: :index, on: :collection, as: 'filter'
  end
  resources :calendar

  namespace :admin do
    root to: 'events#index'
    resources :events
    resources :members do
      get 'download', action: :report, on: :collection
    end
    resources :adresses
    resources :banners
  end
 mount Forem::Engine, :at => "/forums"
end
