class ApplicationController < ActionController::API
  include GraphqlDevise::Concerns::SetUserByToken
  # before_action :authenticate_user!
end
