# Wordsoup

Wordsoup is a gibberish generator that you can use in place of Lorem Ipsum. It generates sentences and paragraphs with regular English syntax in the style of your favorite authors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wordsoup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wordsoup

## Usage

Wordsoup::Shakespeare.sentence
Wordsoup::Shakespeare.paragraph

Wordsoup::Hemingway.sentence
Wordsoup::Hemingway.paragraph

Wordsoup::Bible.sentence
Wordsoup::Bible.paragraph

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DouglasTGordon/WordSoup.
