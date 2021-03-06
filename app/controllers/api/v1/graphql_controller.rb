# frozen_string_literal: true

module Api
  module V1
    class GraphqlController < ApplicationController
      include GraphqlDevise::Concerns::SetUserByToken

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :validation_error

      def graphql
        result = FoodieSchema.execute(params[:query], execute_params(params))

        render json: result unless performed?
      end

      def interpreter
        render json: InterpreterSchema.execute(params[:query], execute_params(params))
      end

      def failing_resource_name
        render json: FoodieSchema.execute(params[:query], context: graphql_context(%i[user fail]))
      end

      private

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def validation_error(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
      end

      def execute_params(item)
        {
          operation_name: item[:operationName],
          variables: ensure_hash(item[:variables]),
          context: graphql_context(%i[user])
        }
      end

      def ensure_hash(ambiguous_param)
        case ambiguous_param
        when String
          if ambiguous_param.present?
            ensure_hash(JSON.parse(ambiguous_param))
          else
            {}
          end
        when Hash, ActionController::Parameters
          ambiguous_param
        when nil
          {}
        else
          raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
        end
      end

      def verify_authenticity_token; end
    end
  end
end
