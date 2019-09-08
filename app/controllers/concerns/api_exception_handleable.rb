# frozen_string_literal: true

module ApiExceptionHandleable
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::Authorizable::NotAuthorizedError, with: :unauthorized
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from StandardError, with: :internal_server_error
  end

  private

  def unauthorized
    head :unauthorized
  end

  def record_invalid(error)
    render json: error, serialzer: Api::RecordInvalidSerializer, status: :unprocessable_entity
  end

  def internal_server_error
    head :internal_server_error
  end
end
