# frozen_string_literal: true

module Api
  module V1
    class ApiController < ::ApplicationController
      include ApiExceptionHandleable
      include JWT::Authorizable
      include JWT::Authenticable
    end
  end
end
