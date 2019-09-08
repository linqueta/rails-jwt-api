# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApiController
      before_action :authenticate, only: :login
      before_action :authorize, only: :logout
      before_action :blacklist!, only: :logout

      def login
        render json: { token: @token }, status: :created
      end

      def logout
        head :ok
      end
    end
  end
end
