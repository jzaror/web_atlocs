Rails.application.routes.draw do

	resources :locations do
	  get :autocomplete_tag_name, :on => :collection
	end
	# pages
	get '/about' => 'pages#about'
	get '/contacto' => 'pages#contact'
	post '/contacto' => 'pages#contact'
	get '/faq' => 'pages#faq'
	get '/terminos-y-condiciones' => 'pages#terms-and-conditions'
	get '/gracias' => 'pages#thanks'
	get '/nueva_locacion' => 'pages#new_location'
	# Sessions
	get '/signup' => 'sessions#register'
	post '/signup' => 'sessions#register'

	get '/login' => 'sessions#new'
	post '/login' => 'sessions#create'
	get '/logout' => 'sessions#destroy'
	get '/help/password' => 'sessions#requestpasswordupdate'
	post '/help/password' => 'sessions#requestpasswordupdate'
	get '/help/updatepassword/:code' => 'sessions#updatepassword'
	post '/help/updatepassword/:code' => 'sessions#updatepassword'
	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".
	# Users
	post 'users' => 'users#create'
	get '/users/:id' => 'users#show'
	get '/users/:id/edit' => 'users#edit'
	patch '/users/update' => 'users#update' 
	root 'welcome#index'


	# bookings
	get 'bookings/new' => 'bookings#new'
	post 'bookings/price' => 'bookings#price'
	get 'bookings/:code' => 'bookings#show'
	get 'bookings/:code/payment/confirm' => "bookings#confirmpayment"
	get 'bookings/:code/accept' => 'bookings#accept'
	get 'bookings/:code/cancel' => 'bookings#cancel'
	get 'bookings/:code/delete' => 'bookings#delete'
	post 'bookings/:code/comment' => 'bookings#comment'
	post 'bookings/create'=> 'bookings#create'
	get "bookings" => "bookings#index"

	# locations
	get 'locations/:id/approve' => 'locations#approve'
	get 'locations/:id/archive' => 'locations#archive'
	get 'locations/:id/destroy' => 'locations#destroy'
	post 'locations/:id/frontpage' => 'locations#frontpage'
	get 'locations/:id/show_archive_modal' => 'locations#show_archive_modal'

	# attachments
	match "upload/:location" => "attachments#create", via: [:post,:patch]
	get "attachments/:id/destroy" => "attachments#destroy"

	#ADMIN
	get '/admin/' => redirect('/admin/locations')
	get '/admin/collections' => 'collections#admin'
	get '/admin/locations' => 'locations#admin'
	get '/admin/users' => 'users#admin'

	resources :collections
	resources :locations

end
