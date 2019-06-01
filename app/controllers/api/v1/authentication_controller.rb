# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize, only: :logout

      def login
        time = ::Auth::JsonWebToken.expiration_time.iso8601
        token = ::Auth::JsonWebToken.encode({})
        # TODO: Check blacklist

        render json: { token: token, exp: time }, status: :created
      end

      def logout
        # TODO: Insert decoded into blacklist
        head :ok
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
