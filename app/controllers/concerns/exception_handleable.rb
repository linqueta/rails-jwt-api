# frozen_string_literal: true

module ExceptionHandleable
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::Authorizable::NotAuthorizedError, with: :unauthorized
  end

  private

  def unauthorized
    head :unauthorized
  end
end
