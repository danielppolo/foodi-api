Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  get '/api/v1/graphql', to: 'api/v1/graphql#graphql'
  post '/api/v1/graphql', to: 'api/v1/graphql#graphql'
  post '/api/v1/interpreter', to: 'api/v1/graphql#interpreter'
  post '/api/v1/failing', to: 'api/v1/graphql#failing_resource_name'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
