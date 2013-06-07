RExam::Application.routes.draw do
  devise_for :users
  resources :users, :only => [:show, :edit, :update]

  mount RailsAdmin::Engine => '/rAdmin', :as => 'rails_admin'

  resources :exams, :only => [] do
    get  'show',    :on => :member
    get  'prepare', :on => :member
    post 'start',   :on => :member
    post 'finish',  :on => :member
  end
  match "/exams/:id/start/:question" => "exams#start", :constraints => { :id => /\d+/, :question => /\d+/ }, :method => :post
  match "/exams/:id/answer/:question" => "exams#answer", :method => :post
  match "/profile/:username/" => "users#show", :as => :profile

  namespace :admin do
    root :to => 'exams#index'
    resources :exams do
      get  'import' => "exams#import_form",    :on => :collection
      post 'import' => "exams#import_prepare", :on => :collection
      put  'import' => "exams#import",         :on => :collection
      delete 'destroy_question', :on => :member
      resources :sections, :only => [] do
        put 'update', :on => :member
      end
    end
    resources :categories, :vendors, :types, :users
  end


 root :to => 'exams#index'

end
