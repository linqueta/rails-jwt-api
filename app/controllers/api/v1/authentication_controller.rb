# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApiController
      before_action :authorize, only: :logout
      before_action :blacklist!, only: :logout

      def login
        return head :unauthorized unless authenticated

        token = ::Auth::JWT.encode(sub: authenticated.id)

        render json: { token: token }, status: :created
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def logout
        head :ok
      end

      private

      def login_params
        params.require(:authentication).permit(:email, :password)
      end

      def authenticated
        @authenticated = User.find_by!(email: login_params[:email]).authenticate(login_params[:password])
      end
    end
  end
end
