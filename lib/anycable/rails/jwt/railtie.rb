# frozen_string_literal: true

require "anycable/rails/jwt/helper"

module AnyCable
  module Rails
    module JWT # :nodoc:
      class Railtie < ::Rails::Railtie # :nodoc:
        initializer "anycable_rails_jwt.helpers" do
          ActiveSupport.on_load(:action_view) do
            include AnyCable::Rails::JWT::Helper
          end
        end
      end
    end
  end
end
