# frozen_string_literal: true

module JWT
  module Authorizable
    class NotAuthorizedError < StandardError; end

    extend ActiveSupport::Concern

    included do
      attr_accessor :user, :decoded
    end

    def authorize
      verify_header!
      build_decode!
      build_user!
    rescue JWT::DecodeError,
           JWT::VerificationError,
           JWT::ExpiredSignature,
           ActiveRecord::RecordNotFound
      raise NotAuthorizedError
    end

    def blacklist!
      verify_header!
      ::Auth::JWT.blacklist!(authorization_header)
    end

    private

    def verify_header!
      raise NotAuthorizedError if authorization_header.blank? || ::Auth::JWT.blacklist?(authorization_header)
    end

    def build_decode!
      @decoded = ::Auth::JWT.decode(authorization_header)
    end

    def build_user!
      @user = User.find(@decoded[:sub])
    end

    def authorization_header
      request.headers['Authorization']&.strip
    end
  end
end
