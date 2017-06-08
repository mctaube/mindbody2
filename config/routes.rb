Rails.application.routes.draw do
  devise_for :users
  # Routes for the Rsvp resource:
  # CREATE
  get "/rsvps/new", :controller => "rsvps", :action => "new"
  post "/create_rsvp", :controller => "rsvps", :action => "create"

  # READ
  get "/rsvps", :controller => "rsvps", :action => "index"
  get "/rsvps/:id", :controller => "rsvps", :action => "show"

  # UPDATE
  get "/rsvps/:id/edit", :controller => "rsvps", :action => "edit"
  post "/update_rsvp/:id", :controller => "rsvps", :action => "update"

  # DELETE
  get "/delete_rsvp/:id", :controller => "rsvps", :action => "destroy"
  #------------------------------

  # Routes for the Resident resource:
  # CREATE
  get "/residents/new", :controller => "residents", :action => "new"
  post "/create_resident", :controller => "residents", :action => "create"

  # READ
  get "/residents", :controller => "residents", :action => "index"
  get "/residents/:id", :controller => "residents", :action => "show"

  # UPDATE
  get "/residents/:id/edit", :controller => "residents", :action => "edit"
  post "/update_resident/:id", :controller => "residents", :action => "update"

  # DELETE
  get "/delete_resident/:id", :controller => "residents", :action => "destroy"
  #------------------------------

  # Routes for the Session resource:
  # CREATE
  get "/sessions/new", :controller => "sessions", :action => "new"
  post "/create_session", :controller => "sessions", :action => "create"

  # READ
  get "/sessions", :controller => "sessions", :action => "index"
  post "/sessions", :controller => "sessions", :action => "index"
  get "/sessions/:id", :controller => "sessions", :action => "show"

  # UPDATE
  get "/sessions/:id/edit", :controller => "sessions", :action => "edit"
  post "/update_session/:id", :controller => "sessions", :action => "update"

  # DELETE
  get "/delete_session/:id", :controller => "sessions", :action => "destroy"
  #------------------------------

  root to: "sessions#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
