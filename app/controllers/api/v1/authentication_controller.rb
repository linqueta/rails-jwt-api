# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        time = ::Auth::JsonWebToken.expiration_time.iso8601
        token = ::Auth::JsonWebToken.encode({})

        render json: { token: token, exp: time }, status: :ok
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
