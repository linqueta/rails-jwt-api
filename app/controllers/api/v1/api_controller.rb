# frozen_string_literal: true

module Api
  module V1
    class ApiController < ::ApplicationController
      include ApiExceptionHandleable
      include JWT::Authenticable
      include JWT::Authorizable
    end
  end
end
