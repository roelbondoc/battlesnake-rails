Rails.application.routes.draw do
  get  '/',      to: 'commands#battlesnake'
  post '/start', to: 'commands#start'
  post '/move',  to: 'commands#move'
  post '/end',   to: 'commands#finished'
end
