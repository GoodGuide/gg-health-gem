Rails.application.routes.draw do
  mount Goodguide::Health::Engine => "/health"
end
