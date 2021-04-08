class FoodieSchema < GraphQL::Schema
  include Types

  use GraphqlDevise::SchemaPlugin.new(
    query: Types::QueryType,
    mutation: Types::MutationType,
    authenticate_default: false,
    resource_loaders: [
      GraphqlDevise::ResourceLoader.new(
        'User',
        only: %i[
          login
          confirm_account
          send_password_reset
          resend_confirmation
          check_password_token
        ]
      )
    ]
  )
  mutation(Types::MutationType)
  query(Types::QueryType)
end
