# frozen_string_literal: true

module Auth
  module JWT
    KEY = Rails.application.secrets.jwt_key.to_s
    EXPIRATION_HOURS = Rails.application.secrets.jwt_expiration_hours.to_i
    BLACKLIST_HEADER = 'jwt_blacklist:'
    DEFAULT_ISSUER = 'API'
    DEFAULT_AUDIENCE = 'HTTP client'

    class << self
      def encode(payload)
        ::JWT.encode(default_payload.merge(payload), KEY)
      end

      def decode(token)
        ::JWT.decode(token, KEY).first.deep_symbolize_keys
      end

      def blacklist!(token)
        Rails.cache.write(blacklist_token(token), true, expires_in: EXPIRATION_HOURS.hours.minutes)
      end

      def blacklist?(token)
        Rails.cache.read(blacklist_token(token))
      end

      private

      def blacklist_token(token)
        "#{BLACKLIST_HEADER}#{token}"
      end

      def default_payload
        {
          iss: DEFAULT_ISSUER,
          aud: DEFAULT_AUDIENCE,
          exp: expiration_time.to_i,
          iat: Time.current.to_i
        }
      end

      def expiration_time
        EXPIRATION_HOURS.hours.from_now
      end
    end
  end
end
