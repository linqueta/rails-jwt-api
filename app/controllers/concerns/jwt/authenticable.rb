# frozen_string_literal: true

module JWT
  module Authenticable
    class NotAuthenticatedError < StandardError; end

    extend ActiveSupport::Concern

    def authenticate
      build_user!
      raise NotAuthenticatedError unless authenticated?

      build_token!
    end

    private

    def login_params
      params.require(:authentication).permit(:email, :password)
    end

    def build_token!
      @token = ::Auth::JWT.encode(sub: @user.id)
    end

    def build_user!
      @user = User.find_by!(login_params.slice(:email))
    end

    def authenticated?
      @user.authenticate(login_params[:password])
    end
  end
end
