# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize, only: :logout

      def login
        user = User.find_by!(email: login_params[:email]).authenticate(login_params[:password])
        return head :unauthorized unless user

        # TODO: Check blacklist
        time = ::Auth::JsonWebToken.expiration_time.iso8601
        token = ::Auth::JsonWebToken.encode(user_id: user.id)

        render json: { token: token, exp: time }, status: :created
      rescue ActiveRecord::RecordNotFound
        head :not_found
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
