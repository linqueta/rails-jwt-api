# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AuthenticationController, type: :controller do
  describe '#login' do
    subject { post :login, params }

    before { subject }

    let(:body) { JSON.parse(response.body).deep_symbolize_keys }

    context 'without params' do
      let(:params) { {} }

      it 'should return success' do
        expect(response.status).to eq(200)
      end

      it 'should return token and expiration time' do
        expect(body[:token]).not_to be_nil
        expect(body[:exp]).not_to be_nil
      end
    end
  end
end
