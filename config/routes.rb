GoodguideHealth::Engine.routes.draw do
  get '/', to: 'application#show'
  get '/status', to: 'application#status'
  get '/error', to: 'application#error'
end
