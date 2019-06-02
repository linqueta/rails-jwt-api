# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ApplicationController
      class WithoutAuthorizationHeader < StandardError; end
      class InBlacklist < StandardError; end

      def authorize
        raise WithoutAuthorizationHeader unless authorization_header
        raise InBlacklist if ::Auth::JsonWebToken.blacklist?(authorization_header)

        @decoded = ::Auth::JsonWebToken.decode(authorization_header)
        @user = User.find(@decoded[:user_id])
      rescue JWT::DecodeError,
             JWT::VerificationError,
             JWT::ExpiredSignature,
             WithoutAuthorizationHeader,
             ActiveRecord::RecordNotFound,
             InBlacklist
        head :unauthorized
      end

      def blacklist!
        raise WithoutAuthorizationHeader unless authorization_header

        ::Auth::JsonWebToken.blacklist!(authorization_header)
      rescue WithoutAuthorizationHeader
        head :unauthorized
      end

      private

      def authorization_header
        request.headers['Authorization']&.strip
      end
    end
  end
end
