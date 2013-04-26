# Ovec

Ovec is a linter for Czech TeX documents inspired by the capabilities of Vlna by Petr Olšák (http://petr.olsak.net/).

## Installation

Add this line to your application's Gemfile:

    gem 'ovec'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ovec

## Usage

Use the installed binary `ovec` as a filter.
Right now, it writes out some debug messages to stderr - this will be fixed in a later version.
Usage example:

    $ cat input.tex | ovec > output.tex

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
