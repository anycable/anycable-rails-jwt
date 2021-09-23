# frozen_string_literal: true

require "spec_helper"

describe AnyCable::Config, type: :config do
  subject(:config) { AnyCable::Config.new }

  around { |ex| with_env("ANYCABLE_JWT_ID_PARAM" => "my_token", &ex) }

  it "loads config vars from anycable.yml and env", :aggregate_failures do
    expect(config.jwt_id_key).to eq "__secret_anycable__"
    expect(config.jwt_id_param).to eq "my_token"
    expect(config.jwt_id_ttl).to eq 300
  end
end
