# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AuthenticationController, type: :controller do
  describe '#login' do
    let!(:user) { create :user }
    subject { post :login, params }

    before { subject }

    context 'with unknown user' do
      let(:params) { {} }

      it 'should return not found' do
        expect(response.status).to eq(404)
      end
    end

    context 'with invalid password' do
      let(:params) { { params: { email: user.email, password: '123' } } }

      it 'should return unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    context 'with valid password' do
      let(:params) { { params: { email: user.email, password: '123456' } } }

      it 'should return created' do
        expect(response.status).to eq(201)
      end

      it 'should return token' do
        expect(body[:token]).not_to be_nil
      end
    end
  end

  describe '#logout' do
    subject { delete :logout }

    before do
      request.headers['Authorization'] = authorization_header
      subject
    end

    let(:body) { JSON.parse(response.body).deep_symbolize_keys }

    context 'without authorization header' do
      let(:authorization_header) { nil }

      it 'should return unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    context 'with invalid token' do
      let(:authorization_header) { '123' }

      it 'should return unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    context 'with expired token' do
      let(:authorization_header) do
        JWT.encode({ exp: 1.hour.ago.to_i }, ::Auth::JsonWebToken::JWT_KEY)
      end

      it 'should return unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    context 'with token in blacklist' do
      let(:authorization_header) do
        ::Auth::JsonWebToken.encode({}).tap do |token|
          ::Auth::JsonWebToken.blacklist!(token)
        end
      end

      it 'should return unauthorized' do
        expect(response.status).to eq(401)
      end
    end

    context 'with valid token' do
      let(:user) { create :user }
      let(:authorization_header) { ::Auth::JsonWebToken.encode(user_id: user.id) }

      it 'should return success' do
        expect(response.status).to eq(200)
      end

      it 'should set in blacklist' do
        expect(::Auth::JsonWebToken.blacklist?(authorization_header)).to be_truthy
      end
    end
  end
end
