# frozen_string_literal: true

require "jwt"
require "json"
require "anycable-rails"

require "anycable/rails/jwt/version"
require "anycable/rails/jwt/config"

module AnyCable
  module Rails
    module JWT
      ALGORITHM = "HS256"

      class << self
        def encode(expires_at: nil, **identifiers)
          key = AnyCable.config.jwt_id_key
          raise ArgumentError, "JWT encryption key is not specified. Add it via `jwt_id_key` option" if key.blank?

          expires_at ||= AnyCable.config.jwt_id_ttl.seconds.from_now

          serialized_ids = identifiers.transform_values { |v| AnyCable::Rails.serialize(v) }

          payload = {ext: serialized_ids.to_json, exp: expires_at.to_i}

          ::JWT.encode(payload, key, ALGORITHM)
        end

        def decode(token)
          key = AnyCable.config.jwt_id_key
          raise ArgumentError, "JWT encryption key is not specified. Add it via `jwt_id_key` option" if key.blank?

          ::JWT.decode(token, key, true, {algorithm: ALGORITHM}).then do |decoded|
            JSON.parse(decoded.first.fetch("ext"))
          end.then do |serialized_ids|
            serialized_ids.transform_values! { |v| AnyCable::Rails.deserialize(v) }
            serialized_ids
          end
        end
      end
    end
  end
end

require "anycable/rails/jwt/railtie" if defined?(Rails::Railtie)
