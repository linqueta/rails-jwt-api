# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'jwt_authenticable' do
  describe '#authenticate' do
    let(:instance) { described_class.new }
    subject { instance.authenticate }

    before { allow(instance).to receive(:params).and_return(params) }

    context 'without authentication params' do
      let(:params) { ActionController::Parameters.new }

      it { expect { subject }.to raise_error(ActionController::ParameterMissing) }
    end

    context 'with authentication params' do
      let(:params) { ActionController::Parameters.new(authentication: user_params) }

      context 'without user' do
        context 'with unknown email' do
          let(:user_params) { { email: 'unknown@gmail.com' } }

          it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
        end
      end

      context 'with user' do
        let!(:user) { create :user }

        context 'with unknown email' do
          let(:user_params) { { email: 'unknown@gmail.com' } }

          it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
        end

        context 'with known email' do
          context 'with invalid password' do
            let(:user_params) { { email: 'lincolnrodrs@gmail.com', password: '123' } }

            it { expect { subject }.to raise_error(JWT::Authenticable::NotAuthenticatedError) }
          end

          context 'with valid password' do
            let(:user_params) { { email: 'lincolnrodrs@gmail.com', password: '123456' } }

            before { subject }

            it { expect(instance.token).to be_a(String) }
            it { expect(instance.subscriber).to be_a(User) }
          end
        end
      end
    end
  end
end
