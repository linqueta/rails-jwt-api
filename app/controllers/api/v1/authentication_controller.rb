# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize, only: :logout
      before_action :blacklist!, only: :logout

      def login
        return head :unauthorized unless authenticated

        token = ::Auth::JsonWebToken.encode(sub: authenticated.id)

        render json: { token: token }, status: :created
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def logout
        head :ok
      end

      private

      def login_params
        params.permit(:email, :password)
      end

      def authenticated
        @authenticated = User.find_by!(email: login_params[:email]).authenticate(login_params[:password])
      end
    end
  end
end
