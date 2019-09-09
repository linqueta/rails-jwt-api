# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UserSerializer, type: :model do
  describe '#to_json' do
    subject { described_class.new(create(:user)).to_json }

    it { is_expected.to match_json_schema('serializers/api/v1/user_serializer') }
  end
end
