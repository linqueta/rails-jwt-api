# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe '#index' do
    subject { get :index }

    context 'without authentication' do
      before { subject }

      it 'should return unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    context 'with authentication' do
      before { authorize && subject }

      it 'should return success' do
        expect(response.status).to eq(200)
      end

      it 'should return an users array' do
        expect(body.any?).to be_truthy
      end

      it 'should match with schema' do
        expect(response.body).to match_response_schema('controllers/api/v1/users_index')
      end
    end
  end
end
