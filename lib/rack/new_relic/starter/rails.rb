# frozen_string_literal: true

require 'rack/new_relic/starter'

module Rack
  module NewRelic
    class Starter
      # Rack::NewRelic::Starter::Railtie implements a railtie which creates an
      # initializer to add the middleware to the middleware stack with the
      # default options.
      class Railtie < Rails::Railtie
        initializer 'rack-new_relic-starter.middleware' do |app|
          app.middleware.use Rack::NewRelic::Starter
        end
      end
    end
  end
end
