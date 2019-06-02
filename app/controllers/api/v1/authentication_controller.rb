# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize, only: :logout
      before_action :blacklist!, only: :logout

      def login
        user = User.find_by!(email: login_params[:email]).authenticate(login_params[:password])
        return head :unauthorized unless user

        time = ::Auth::JsonWebToken.expiration_time.iso8601
        token = ::Auth::JsonWebToken.encode(user_id: user.id)

        render json: { token: token, exp: time }, status: :created
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
    end
  end
end
