FreeLibraryOnRails::Application.routes.draw do
	# See how all your routes lay out with "rake routes"
	# The priority is based upon order of creation: first created -> highest priority.

	resources :items do
		collection { get :search }
	end

	resources :books do
		collection { get :search }
	end

	resources :videos do
		collection { get :search }
	end

	match 'users/:id/search' => 'users#search'
	resources :users, :constraints => { :id => %r([^/;,?\.]+) } do
		member do
			post :comments
			post :librarian
		end
	end

	resources :loans
	resources :tags, :constraints => { :id => %r(.+) } do
		collection { get :autocomplete }
	end

	match 'about' => 'welcome#about'
	match 'new'   => 'welcome#new_things'

	match '/account/login' => 'account#login', :as => :login
	match '/account/signup' => 'account#signup', :as => :signup
	match '/account/invite' => 'account#invite', :as => :invite
	post '/account/leave_librarian' => 'account#leave_librarian', :as => :leave_librarian
	post '/account/activate' => 'account#request_activation', :as => :request_activation
	get '/account/activate/:id' => 'account#activate', :as => :activate

	root :to => 'welcome#index'

	# Install the Rails 2 default routes as the lowest priority.
	#   I try to avoid falling back on these -- bct
	match '/:controller(/:action(/:id))'
end
