# frozen_string_literal: true

module JWT
  module Authenticable
    class NotAuthenticatedError < StandardError; end

    extend ActiveSupport::Concern

    included do
      attr_accessor :token, :subscriber
    end

    def authenticate
      build_subscriber!
      raise NotAuthenticatedError unless authenticated?

      build_token!
    end

    private

    def authentication_params
      params.require(:authentication).permit(:email, :password)
    end

    def build_token!
      @token = ::Auth::JWT.encode(sub: @subscriber.id)
    end

    def build_subscriber!
      @subscriber = User.find_by!(authentication_params.slice(:email))
    end

    def authenticated?
      @subscriber.authenticate(authentication_params[:password])
    end
  end
end
