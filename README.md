# Spiderman

A minimalistic web crawler.

## Installation

The following assumes Git, Ruby and the Bundler gem are installed.

Clone the GitHub repository

```bash
git clone https://github.com/rolfhsp/spiderman.git
```

A specific tagged version may also be given

```bash
git clone https://github.com/rolfhsp/spiderman.git --branch v0.0.2
```

Enter the folder and run

```bash
$ bundle
$ bundle exec rake install
```

## Usage

```bash
spiderman [OPTION]... URL
```

### Options
-h, --help      Show helptext

### Examples
```bash
$ spiderman -h
$ spiderman -v
$ spiderman http://www.vg.no
```

## Development

Currently this is a solo project for personal usage.

## Contributing

No need at the moment, thanks.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

