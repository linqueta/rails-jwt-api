# frozen_string_literal: true

module JWT
  module Authorizable
    class NotAuthorizedError < StandardError; end

    extend ActiveSupport::Concern

    def authorize
      raise NotAuthorizedError unless authorization_header && !::Auth::JWT.blacklist?(authorization_header)

      build_decode!
      build_user!
    rescue JWT::DecodeError,
           JWT::VerificationError,
           JWT::ExpiredSignature,
           ActiveRecord::RecordNotFound
      raise NotAuthorizedError
    end

    def blacklist!
      raise NotAuthorizedError unless authorization_header

      ::Auth::JWT.blacklist!(authorization_header)
    end

    private

    def build_decode!
      @decoded = ::Auth::JWT.decode(authorization_header)
    end

    def build_user!
      @user = User.find(@decoded[:user_id])
    end

    def authorization_header
      request.headers['Authorization']&.strip
    end
  end
end