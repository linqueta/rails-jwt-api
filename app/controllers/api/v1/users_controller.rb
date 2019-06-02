# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize

      def index
        render json: Api::V1::UserSerializer.new(User.all.select(:id, :name, :email))
      end

      def update
        if @user.update(user_params)
          render json: Api::V1::UserSerializer.new(@user)
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email)
      end
    end
  end
end
