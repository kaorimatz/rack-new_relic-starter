# frozen_string_literal: true

require 'new_relic/agent'
require 'rack/body_proxy'

module Rack
  module NewRelic
    # Rack::NewRelic::Starter is a Rack middleware that provides an endpoint to
    # start the New Relic agent.
    class Starter
      # Rack::NewRelic::Starter::Error is a base class for errors raised by
      # {Starter} and {Latch}.
      class Error < StandardError; end

      autoload :Latch, 'rack_new_relic_starter'

      # Returns a new {Starter} which implements the Rack interface.
      #
      # @param app [Object] the Rack application
      # @param latch [Rack::NewRelic::Starter::Latch] the latch object
      # @param path [String] the path of the endpoint to start the New Relic
      #   agent
      # @return [Rack::NewRelic::Starter] A new starter object
      def initialize(app, latch: Latch.new, path: nil)
        @app = app
        @latch = latch
        @path = path || '/_new_relic/start'
        @started = false
      end

      # Starts the New Relic agent if the path of the request matches with the
      # path of the endpoint or the latch is opened.
      #
      # @param env [Hash] the Rack environment
      # @return [Array] the Rack response
      def call(env)
        start! if !@started && @latch.opened?

        if env['PATH_INFO'] == @path
          handle
        else
          @app.call(env)
        end
      end

      private

      def handle
        if @started
          headers = { 'Content-Type' => 'text/plain' }
          [200, headers, ['The New Relic agent is already started.']]
        else
          @latch.open!
          start!
          headers = { 'Content-Type' => 'text/plain' }
          [200, headers, ['Started the New Relic agent.']]
        end
      end

      def start!
        ::NewRelic::Agent.manual_start
        @started = true
      end
    end
  end
end
