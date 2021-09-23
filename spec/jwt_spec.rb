# frozen_string_literal: true

require "spec_helper"

describe AnyCable::Rails::JWT do
  let(:user) { User.create!(name: "Ann") }
  let(:payload) { {user: user, tenant: "any"} }

  it "re-raises decode error" do
    token = described_class.encode(**payload)

    token[0] = token[0].succ

    expect { described_class.decode(token) }.to raise_error(JWT::DecodeError)
  end

  it "raise expire error when expired" do
    token = described_class.encode(**payload, expires_at: 1.minute.ago)

    expect { described_class.decode(token) }.to raise_error(JWT::ExpiredSignature)
  end

  it "encodes identifiers via AnyCable::Rails.serialize" do
    allow(AnyCable::Rails).to receive(:serialize).and_call_original

    token = described_class.encode(**payload)

    expect(AnyCable::Rails).to have_received(:serialize).with(user)
    expect(AnyCable::Rails).to have_received(:serialize).with("any")

    decoded = described_class.decode(token)

    expect(decoded["user"]).to eq(user)
    expect(decoded["tenant"]).to eq("any")
  end
end
