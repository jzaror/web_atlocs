Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", confirmations: 'users/confirmations'}
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
	resources :locations do
	  get :autocomplete_tag_name, :on => :collection
	  member do
 	 		get 'request_removal'
  	end
	end

	root 'welcome#index'

		# pages
		get '/about' => 'pages#about'
		get '/contacto' => 'pages#contact', as: 'contact'
		post '/contacto' => 'pages#contact'
		get '/faq' => 'pages#faq'
		get '/terminos-y-condiciones' => 'pages#terms-and-conditions', as: 'terms_conditions'
		get '/gracias' => 'pages#thanks'
		get '/nueva_locacion' => 'pages#new_location'
		# Sessions
		# get '/signup' => 'sessions#register'
		# post '/signup' => 'sessions#register'
		get '/signup' => 'users#new', as: 'new_session'
		post '/users/new' => 'users#create'
	  get 'request_annulation/:id' => 'users#request_annulation', as: 'user_annulation'
		get '/login' => 'sessions#new'
		post '/login' => 'sessions#create'
		get '/logout' => 'sessions#destroy'
		get '/help/password' => 'sessions#requestpasswordupdate'
		post '/help/password' => 'sessions#requestpasswordupdate'
		get '/help/updatepassword/:code' => 'sessions#updatepassword', as: 'update_password'
		post '/help/updatepassword/:code' => 'sessions#updatepassword'
	  get 'location/:id/show_modal' => 'locations#request_removal', as: 'delete_location_modal'
	  get 'location/:id/request_del' => 'locations#delete_request', as: 'location_delete'
		# The priority is based upon order of creation: first created -> highest priority.
		# See how all your routes lay out with "rake routes".
		# Users
		resources :users, except: [:index, :edit, :update] do
			collection do
				get :edit
			end
		end
		patch '/users/update' => 'users#update'
		get '/set_locale/' => 'users#set_locale'

		# bookings
		get 'bookings/new' => 'bookings#new'
		get 'bookings/:id/edit', to: 'bookings#edit', as: 'edit_booking'
	  post 'bookings/:id/edit', to: 'bookings#update'
		post 'bookings/price' => 'bookings#price'
		get 'bookings/:code' => 'bookings#show', as: 'booking'
		get 'bookings/:code/payment/confirm' => "bookings#confirmpayment"
		get 'bookings/:code/accept' => 'bookings#accept', as: 'booking_accept'
		get 'bookings/:code/cancel' => 'bookings#cancel', as: 'booking_cancel'
		get 'bookings/:code/delete' => 'bookings#delete'
		delete "bookings/:id" => "bookings#destroy"
		post 'bookings/:code/comment' => 'bookings#comment'
		post 'bookings/create'=> 'bookings#create'
		get "bookings" => "bookings#index"
	  get 'booking/:id/cancel_modal' => "bookings#cancel_modal", as: 'cancel_booking'
	  get 'booking/:id/cancel' => 'bookings#cancel_booking', as: 'booking_cancelled'

		# locations
		get 'locations/:id/approve' => 'locations#approve', as: 'approve_location'
		get 'locations/:id/archive' => 'locations#archive'
		delete 'locations/:id/destroy' => 'locations#destroy'
		get 'locations/:id/re_send_reject_email' => 'locations#re_send_reject_email'
		post 'locations/:id/frontpage' => 'locations#frontpage'
		get 'locations/:id/show_archive_modal' => 'locations#show_archive_modal'
		get 'locations/:id/show_contact_modal' => 'locations#show_contact_modal'
		put "locations/:id/feature_image" => "locations#feature_image"
	  # attachments
		match "upload/:location" => "attachments#create", via: [:post,:patch]
		get "attachments/:id/destroy" => "attachments#destroy"
	  get 'users/:id/delete_modal' => 'users#request_delete', as: 'delete_modal'
	  get "uploads/:id/destroy" => "uploads#destroy"

		#ADMIN
		get '/admin/' => redirect('/admin/locations')
		get '/admin/collections' => 'collections#admin'
		get '/admin/locations' => 'locations#admin'
		get '/admin/users' => 'users#admin'
		get '/admin/bookings' => 'bookings#admin'

		resources :bookings
		resources :collections
		resources :locations


	resources :confs, only: [:index] do
    collection do
      get :edit
      post :update
    end
  end

end
