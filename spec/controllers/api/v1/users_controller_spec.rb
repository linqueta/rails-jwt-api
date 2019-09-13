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
end
