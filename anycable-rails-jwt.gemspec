# frozen_string_literal: true

require_relative "lib/anycable/rails/jwt/version"

Gem::Specification.new do |s|
  s.name = "anycable-rails-jwt"
  s.version = AnyCable::Rails::JWT::VERSION
  s.authors = ["Vladimir Dementyev"]
  s.email = ["dementiev.vm@gmail.com"]
  s.homepage = "http://github.com/anycable/anycable-rails-jwt"
  s.summary = "AnyCable Rails helpers for JWT-based authentication"
  s.description = "AnyCable Rails helpers for JWT-based authentication"

  s.metadata = {
    "bug_tracker_uri" => "http://github.com/anycable/anycable-rails-jwt/issues",
    "changelog_uri" => "https://github.com/anycable/anycable-rails-jwt/blob/master/CHANGELOG.md",
    "documentation_uri" => "http://github.com/anycable/anycable-rails-jwt",
    "homepage_uri" => "http://github.com/anycable/anycable-rails-jwt",
    "source_code_uri" => "http://github.com/anycable/anycable-rails-jwt"
  }

  s.license = "MIT"

  s.files = Dir.glob("lib/**/*") + Dir.glob("bin/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.7"

  s.add_dependency "anycable-rails-core", "~> 1.1", "< 1.5.0"
  s.add_dependency "jwt", "~> 2.2"

  s.add_development_dependency "bundler", ">= 1.15"
  s.add_development_dependency "combustion", ">= 1.1"
  s.add_development_dependency "rake", ">= 13.0"
  s.add_development_dependency "rspec-rails", ">= 4.0"
end
