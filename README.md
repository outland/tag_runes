# Outland::TagRunes

The Outland TagRunes gem adds unicode glyphs to the Rails logger output that encode the session and
request id in a way that occupies a minimum of visual space but provides very useful debugging
capabilities.

For example, it is easy to grep for a single session's log output, or the log output for a complete
request, even if many requests are interleaved into the same log file.

Beyond the debugging capabilities, TagRunes tries to keep the log file output pleasant to work
with by only occupying 10 columns of text.  It uses unicode to encode a full byte of data into each
column position in a visually clear way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'outland-tag_runes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install outland-tag_runes

## Usage

In your initialization, add:

    config.log_tags = [ Outland::TagRunes.rails_tag ]

Your log output will look something like the following.
    
    [★¿xÄ ϱm] Completed 200 OK in 78ms (Views: 0.7ms | ActiveRecord: 72.6ms)

The format is:

    [<encoded session id> <encoded request id>]

So to look at a user's complete session log output, do the following:

    grep "<encoded session id>" production.log

Or for a particular request:

    grep "<encoded request id>" production.log

The tag is added to the Rack environment, so tools like Airbrake will contain it in
their exception environment information.  You can therefore look at a recorded exception
and quickly produce the entire log output for that request.
  
The gem also wraps the standard Rails log formatter so that multiline log messages will be
tagged properly on each line.

The glyphs were chosen for legibility in OSX terminal fonts.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/outland/tag_runes.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

