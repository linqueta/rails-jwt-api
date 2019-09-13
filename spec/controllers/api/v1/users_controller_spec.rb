# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe '#index' do
    subject { get :index }

    before { authorization.then { subject } }

    context 'without authorization' do
      let(:authorization) { nil }

      it { expect(response.status).to eq(401) }
    end

    context 'with authorization' do
      let(:authorization) { authorize }

      it { expect(response.status).to eq(200) }
    end
  end

  describe '#update' do
    let(:params) { { params: { id: 1, user: { email: 'linqueta@gmail.com' } } } }

    subject { patch :update, params }

    before { authorization.then { subject } }

    context 'without authorization' do
      let(:authorization) { nil }

      it { expect(response.status).to eq(401) }
    end

    context 'with authorization' do
      let(:authorization) { authorize }

      context 'unknown user' do
        let(:authorization) { authorize.then { User.destroy_all } }

        it { expect(response.status).to eq(401) }
      end

      context 'known user' do
        it { expect(response.status).to eq(200) }
      end
    end
  end
end
