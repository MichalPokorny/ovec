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
Usage example:

    $ cat input.tex | ovec > output.tex

You may also pass input files as command-line arguments. If you pass multiple files, they will be concatenated, and filtered as one file.

    $ ovec input1.tex input2.tex input3.tex > output.tex

You can use the `-o` (`--output`) option to specify an output file:

    $ ovec input.tex -o output.tex

Other options include `-d` (or `--[no-]debug`) for showing debugging messages on STDERR,
`-v` (`--version`), which tells you the installed version of Ovec, and `-h` (`--help`),
which shows a concise summary of available options and flags.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
