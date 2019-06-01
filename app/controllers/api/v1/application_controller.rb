# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ApplicationController
      class WithoutAuthorizationHeader < StandardError; end

      def authorize
        raise WithoutAuthorizationHeader unless authorization_header

        @decoded = ::Auth::JsonWebToken.decode(request.headers['Authorization'].strip)
      rescue JWT::DecodeError,
             JWT::VerificationError,
             JWT::ExpiredSignature,
             WithoutAuthorizationHeader
        head :unauthorized
      end

      private

      def authorization_header
        request.headers['Authorization']
      end
    end
  end
end
