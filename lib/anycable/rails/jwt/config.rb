# frozen_string_literal: true

require "anycable/config"
# Make sure Rails extensions for Anyway Config are loaded
# See https://github.com/anycable/anycable-rails/issues/63
require "anyway/rails"

# Extend AnyCable configuration with jwt_id_key, jwt_id_param, jwt_id_ttl.
AnyCable::Config.attr_config(
  :jwt_id_key,
  jwt_id_param: "jid",
  jwt_id_ttl: 3600
)
