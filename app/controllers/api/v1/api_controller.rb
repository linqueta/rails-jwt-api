# frozen_string_literal: true

module Api
  module V1
    class ApiController < ::ApplicationController
      include ExceptionHandleable
      include JWT::Authorizable
    end
  end
end
