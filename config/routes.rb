Rails.application.routes.draw do
  resource :health, :controller => 'health', :only => [:show] do
    get 'status'
    get 'error'
  end
end
