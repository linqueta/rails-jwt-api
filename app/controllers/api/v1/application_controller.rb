# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ApplicationController
      class WithoutAuthorizationHeader < StandardError; end

      def authorize
        raise WithoutAuthorizationHeader unless authorization_header

        @decoded = ::Auth::JsonWebToken.decode(request.headers['Authorization'].strip)
        @user = User.find(@decoded[:user_id])
      rescue JWT::DecodeError,
             JWT::VerificationError,
             JWT::ExpiredSignature,
             WithoutAuthorizationHeader,
             ActiveRecord::RecordNotFound
        head :unauthorized
      end

      private

      def authorization_header
        request.headers['Authorization']
      end
    end
  end
end
