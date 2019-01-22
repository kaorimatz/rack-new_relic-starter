# frozen_string_literal: true

require 'rack/new_relic/starter'
use Rack::NewRelic::Starter
run ->(_) { [200, { 'Content-Type' => 'text/plain' }, ['OK']] }
