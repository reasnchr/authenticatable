Rails.application.routes.draw do
	scope %w[ api internal ], module: :authenticatable, defaults: { format: :json } do
		resources :users, only: :create do
			post :authorize, on: :collection
		end
	end
end
