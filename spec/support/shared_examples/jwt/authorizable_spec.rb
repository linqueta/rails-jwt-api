# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'jwt_authorizable' do
  describe '#authorize' do
    let(:instance) { described_class.new }
    let(:request) { double(:request, headers: double(:headers, :[] => header)) }
    subject { instance.authorize }

    before { allow(instance).to receive(:request).and_return(request) }

    context 'without header' do
      let(:header) { '' }

      it { expect { subject }.to raise_error(JWT::Authorizable::NotAuthorizedError) }
    end

    context 'with header' do
      let(:sub) { SecureRandom.uuid }
      let(:header) { ::Auth::JWT.encode(sub: sub) }

      context 'in blacklist' do
        before { ::Auth::JWT.blacklist!(header) }

        it { expect { subject }.to raise_error(JWT::Authorizable::NotAuthorizedError) }
      end

      context 'out of blacklist' do
        context 'without user' do
          it { expect { subject }.to raise_error(JWT::Authorizable::NotAuthorizedError) }
        end

        context 'with user' do
          let(:user) { create :user }
          let(:sub) { user.id }
          before { subject }

          it { expect(instance.decoded).to be_a(Hash) }
          it { expect(instance.user).to be_a(User) }
        end
      end
    end
  end
end
