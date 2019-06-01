# frozen_string_literal: true

module Auth
  module JsonWebToken
    JWT_KEY = Rails.application.secrets.jwt_key.to_s
    JWT_EXPIRATION_HOURS = Rails.application.secrets.jwt_expiration_hours.to_i

    class << self
      def encode(payload)
        JWT.encode({ exp: expiration_time.to_i }.merge(payload), JWT_KEY)
      end

      def decode(token)
        JWT.decode(token, JWT_KEY).first.deep_symbolize_keys
      end

      def expiration_time
        JWT_EXPIRATION_HOURS.hours.from_now
      end
    end
  end
end
