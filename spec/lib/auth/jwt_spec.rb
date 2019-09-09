# frozen_string_literal: true

require 'rails_helper'

describe Auth::JWT, type: :module do
  describe '.encode' do
    let(:payload) { { sub: 1 } }
    let(:params) do
      {
        aud: 'HTTP client',
        exp: 1_567_998_000,
        iat: 1_567_911_600,
        iss: 'API',
        sub: 1
      }
    end
    subject { described_class.encode(payload) }

    it do
      Timecop.freeze(Time.parse('08-09-2019')) do
        expect(::JWT).to receive(:encode).with(params, described_class::KEY).once
        subject
      end
    end
    it { is_expected.to be_a(String) }
    it { expect(subject.split('.').length).to eq(3) }
  end

  describe '.decode' do
    let(:payload) { { sub: 1 } }
    let(:token) { described_class.encode(payload) }
    let(:params) do
      {
        aud: 'HTTP client',
        exp: 1_567_998_000,
        iat: 1_567_911_600,
        iss: 'API',
        sub: 1
      }
    end
    subject { described_class.decode(token) }

    it do
      Timecop.freeze(Time.parse('08-09-2019')) do
        is_expected.to eq(params)
      end
    end
  end

  describe '.blacklist!' do
    let(:payload) { { sub: 1 } }
    let(:token) { described_class.encode(payload) }
    subject { described_class.blacklist!(token) }

    context 'before' do
      it { expect(described_class.blacklist?(token)).to be_falsey }
    end

    context 'after' do
      before { subject }

      it { expect(described_class.blacklist?(token)).to be_truthy }
    end
  end

  describe '.blacklist?' do
    let(:payload) { { sub: 2 } }
    let(:token) { described_class.encode(payload) }
    subject { described_class.blacklist?(token) }

    context 'without blacklist token' do
      it { is_expected.to be_falsey }
    end

    context 'with blacklist token' do
      before { described_class.blacklist!(token) }

      it { is_expected.to be_truthy }
    end
  end
end
