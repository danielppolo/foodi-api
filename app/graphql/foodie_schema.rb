class FoodieSchema < GraphQL::Schema
  use GraphqlDevise::SchemaPlugin.new(
    query: Types::QueryType,
    mutation: Types::MutationType,
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
