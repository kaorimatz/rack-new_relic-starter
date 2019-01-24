# Rack::NewRelic::Starter

[![Gem](https://img.shields.io/gem/v/rack-new_relic-starter.svg?style=flat-square)](https://rubygems.org/gems/rack-new_relic-starter)
[![Travis](https://img.shields.io/travis/kaorimatz/rack-new_relic-starter.svg?style=flat-square)](https://travis-ci.org/kaorimatz/rack-new_relic-starter)

A Rack middleware that provides an endpoint to start the New Relic agent.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-new_relic-starter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-new_relic-starter

## Usage

By default, the middleware uses the path `/_new_relic/start` to provide an endpoint to start the New Relic agent:

```ruby
# config.ru
require 'rack/new_relic/starter'
use Rack::NewRelic::Starter
```

You can specify the path of the endpoint using the `path` option:

```ruby
# config.ru
require 'rack/new_relic/starter'
use Rack::NewRelic::Starter, path: '/foo'
```

If your Rack web server is a pre-forking web server and doesn't load the Rack application before forking, you will need to create a global latch object before forking:

```ruby
$latch = Rack::NewRelic::Starter::Latch.new

# config.ru
require 'rack/new_relic/starter'
use Rack::NewRelic::Starter, latch: $latch
```

### Rails

You can configure Rails to add the middleware to the middleware stack with the default options by requiring `rack/new_relic/starter/rails.rb`:

```ruby
# Gemfile
gem 'rack-new_relic-starter', require: 'rack/new_relic/starter/rails'
```

If you need to specify options, you can manually configure the middleware:

```ruby
# config/initializers/rack_new_relic_starter.rb
Rails.application.config.middleware.use Rack::NewRelic::Starter, path: '/foo'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kaorimatz/rack-new_relic-starter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

The idea of starting the New Relic agent using the Rack middleware is borrowed from [partiarelic](https://github.com/wata-gh/partiarelic).
