# frozen_string_literal: true

require 'rails_helper'

describe Auth::JWT, type: :module do
  describe '#encode' do
    subject { described_class.encode(payload) }

    context 'with nil payload' do
      let(:payload) { nil }

      it 'should raise TypeError' do
        expect { subject }.to raise_error(TypeError)
      end
    end

    context 'with user payload' do
      let(:payload) { { user_id: 1 } }

      it 'should encode the payload' do
        is_expected.to be_a(String)
      end
    end
  end

  describe '#decode' do
    let(:payload) { { user_id: 1 } }
    subject { described_class.decode(token) }

    context 'with nil token' do
      let(:token) { nil }

      it 'should raise JWT::DecodeError' do
        expect { subject }.to raise_error(JWT::DecodeError, 'Nil JSON web token')
      end
    end

    context 'with changed token' do
      let(:token) { "#{described_class.encode(payload)}123" }

      it 'should raise JWT::VerificationError' do
        expect { subject }.to raise_error(JWT::VerificationError, 'Signature verification raised')
      end
    end

    context 'with expired token' do
      let(:token) { described_class.encode(payload) }

      before { allow(described_class).to receive(:expiration_time).and_return(1) }

      it 'should raise JWT::ExpiredSignature' do
        expect { subject }.to raise_error(JWT::ExpiredSignature, 'Signature has expired')
      end
    end

    context 'with valid token' do
      let(:token) { described_class.encode(payload) }

      it 'should return user_id encoded' do
        expect(subject[:user_id]).to eq(payload[:user_id])
      end
    end
  end
end
