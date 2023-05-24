Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :games, only: [:index, :show, :create, :update, :destroy] do
        resources :cells, only: [] do
          member do
            patch :flag, to: 'cells#flag'
            patch :reveal, to: 'cells#reveal'
          end
        end
      end
    end
  end
end
