# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize

      def index
        render json: User.all.select(:id, :name, :email), each_serializer: UserSerializer
      end

      private

      def user_params
        params.permit(:name, :email, :password)
      end
    end
  end
end
