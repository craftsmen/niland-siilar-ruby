# Siilar Ruby Client [![Build Status](https://travis-ci.org/craftsmen/niland-siilar-ruby.svg?branch=better-methods-names)](https://travis-ci.org/craftsmen/niland-siilar-ruby)

A Ruby client for the [Siilar API](http://api.siilar.com/1.0/doc/).

## Installation

Add this line to your application's Gemfile:

    gem 'siilar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install siilar

## Usage

This library is a Ruby client you can use to interact with the [Siilar API](http://api.siilar.com/1.0/doc/).

Here's a short example.

```ruby
require 'siilar'

client = Siilar::Client.new(api_key: 'YOUR_KEY')

# Create a track
track = client.tracks.create(title: 'Nine Lives', external_id: '123')
puts "Track: %s (id: %d)" % [track.title, track.id]

# Search for similar tracks
tracks = client.search.similar(similar_ids: '1234')
tracks.each do |track|
  puts "Track: %s (id: %d)" % [track.title, track.id]
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/craftsmen/niland-siilar-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
