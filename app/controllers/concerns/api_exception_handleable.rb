# frozen_string_literal: true

module ApiExceptionHandleable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :internal_server_error
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from JWT::Authenticable::NotAuthenticatedError, with: :not_found
    rescue_from JWT::Authorizable::NotAuthorizedError, with: :unauthorized
  end

  private

  def unauthorized
    head :unauthorized
  end

  def record_invalid(error)
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def internal_server_error
    head :internal_server_error
  end

  def not_found
    head :not_found
  end
end
