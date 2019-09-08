# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :authorize

      def index
        render json: User.all, each_serializer: Api::V1::UserSerializer
      end

      def update
        @user.update!(user_params).then { render json: @user, serializer: Api::V1::UserSerializer }
      end

      private

      def user_params
        params.require(:user).permit(:name, :email)
      end
    end
  end
end
