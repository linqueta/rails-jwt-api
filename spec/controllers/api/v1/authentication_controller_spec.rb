# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AuthenticationController, type: :controller do
  describe '#login' do
    let!(:user) { create :user }
    subject { post :login, params }

    before { subject }

    context 'without authentication params' do
      let(:params) { {} }

      it { expect(response.status).to eq(422) }
    end

    context 'with authentication params' do
      let(:params) { { params: { authentication: user_params } } }

      context 'without user' do
        context 'with unknown email' do
          let(:user_params) { { email: 'unknown@gmail.com' } }

          it { expect(response.status).to eq(404) }
        end
      end

      context 'with user' do
        context 'with unknown email' do
          let(:user_params) { { email: 'lincolnrodrs@gmail.com', password: '123' } }

          it { expect(response.status).to eq(404) }
        end

        context 'with valid password' do
          let(:user_params) { { email: 'lincolnrodrs@gmail.com', password: '123456' } }

          it { expect(response.status).to eq(201) }
          it { expect(response.body).to match_json_schema('controllers/api/v1/authentication/login') }
        end
      end
    end
  end

  describe '#logout' do
    subject { delete :logout }

    before do
      request.headers['Authorization'] = token
      subject
    end

    context 'without token' do
      let(:token) { nil }

      it { expect(response.status).to eq(401) }
    end

    context 'with token' do
      context 'in blacklist' do
        let(:token) { '123'.tap { |t| ::Auth::JWT.blacklist!(t) } }

        it { expect(response.status).to eq(401) }
      end

      context 'out of blacklist' do
        context 'invalid token' do
          let(:token) { '123' }

          it { expect(response.status).to eq(401) }
        end

        context 'valid token' do
          context 'unkown user' do
            let(:token) { ::Auth::JWT.encode(sub: 0) }

            it { expect(response.status).to eq(401) }
          end

          context 'known user' do
            let(:user) { create :user }
            let(:token) { ::Auth::JWT.encode(sub: user.id) }

            it { expect(response.status).to eq(200) }
            it { expect(::Auth::JWT.blacklist?(token)).to be_truthy }
          end
        end
      end
    end
  end
end
