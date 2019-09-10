# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ApiController, type: :controller do
  it_behaves_like 'jwt_authenticable'
  it_behaves_like 'jwt_authorizable'
end
