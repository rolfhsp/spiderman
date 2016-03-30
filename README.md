# Spiderman

A minimalistic web crawler.

## Installation

The following assumes Git, Ruby and the Bundler gem are installed.

### Alternative 1

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
### Alternative 2

If you have access to the spiderman.gem file (ask the owner...),
install with

```bash
gem install spiderman.gem
```
(Please be aware I'm not the owner of spiderman on rubygems.org, so make sure to use the filename with file extension.)

## Usage

spiderman [options]

### Options

```bash
Usage: spiderman [options]

Default values are given in parenthesis

Specific options:
        --url URL                    Setting the Base URL. (http://www.example.com)
    -s, --site                       Crawl single site only. (false)
    -d, --depth N                    Maximum crawl depth, counting the Base URL. (1)
    -u, --urls N                     Maximum number of urls to discover (10000)

Common options:
        --verbose                    Verbose output. (false)
    -h, --help                       Show this message
    -v, --version                    Show version
```

### Output

The standard output is a comma separated string for each URL discovered

```bash
$ bin/spiderman --url http://www.vg.no/sport --depth 1 -u 10
4877e65e13, 1, 1, 1, 0, 0, http://www.vg.no/sport
a01269a0e3, 2, 2, 2, 0, 0, https://"
2195688836, 2, 3, 3, 0, 0, http://"
68252196e8, 2, 4, 4, 0, 0, http://1.vgc.no/vgnett-prod/img/vgLogoSquare.png
b0814eb7fb, 2, 5, 5, 0, 0, http://www.vg.no/rss/feed
2d0daba883, 2, 6, 6, 0, 0, http://www.vektklubb.no
7237d10309, 2, 7, 7, 0, 0, http://www.minmote.no
8471b8df44, 2, 8, 8, 0, 0, http://www.godt.no
2c7c691518, 2, 9, 9, 0, 0, http://vgd.no
10e33d7b31, 2, 10, 10, 0, 0, http://heltnormalt.no
```

Every time a new unique URL is discovered, a line is output.
The fields are:

1. URL Id, a 10 char hex digest of the discovered unique URL string.
2. The URL's crawl depth. E.g. a level of 2 means that URL was discovered while crawling a web page on level 1.
3. The number of discovered matching URLs.
4. The number of unique URLs in the queue for possible later crawling/scraping.
5. The number of unique URLs successfully crawled/scraped.
6. The number of unique URLs failed to, or discarded from, being crawled/scraped,
     due to misc. errors, content types etc.
7. The URL string discovered.

### Examples

Crawl from a given URL, find max 10000 URLs and crawl max down to 3 levels (counting the Base URL).

```bash
$ spiderman --url http://www.vg.no -d 3 -u 10000
```

Crawl a single site from a given URL, crawl max 10 levels, find max 1000 URLs and output verbosely

```bash
$ spiderman --url http://www.cnn.com --site --depth 10 --urls 1000 --verbose
```

## Implementation

The application is built as a standard Ruby gem using

```bash
$ bundle gem spiderman -t=minitest
```

The executable 'spiderman' is in the bin folder

The core application in the lib folder consists mainly of 3 parts:

1. A command line interface (CLI)
2. A crawler, handling the discovery, queueing and content retrieval from URLs
3. A scraper, handling the scanning for text elements in content, most importantly new URLs for the crawler.

There are Minitest-based tests in the test folder.

RDoc documentation is easily generated with

```bash
rake rdoc
```

## (Possible) Future improvements

* File or DB based persistence layer to store results and allow for the resuming of broken jobs.
* Increase test coverage. Currently it covers just the command line interface.
* Improve the URL matching regular expression. Currently doing just a crude regexp scan of the whole page.
  Non-default ports will not be registered, so crawling of those URLs will fail.
* Could make more intelligent use of HTTP tags, like "href" etc. and only scan within HTML body.
* More intelligent use of web-page metadata, like content type etc.
* Site-only option to not reuse the whole Base URL, but use only (parts of) the FQDN.
  E.g. if the Base URL is "http://www.vg.no/sport", then allow for xxxx://x.x.vg.no/x.
* Memory/speed optimalization
* Advanced queuing and scaling with several processes/threads.
* Input file with list of allowed sites for a targeted multisite crawl, e.g. for related sites,
  not covered by the site_only option.
* Analyse some causes for failed URL scrape. Currently all errors goes to common exception code which
  sets the URL crawl to failed. One thing I saw was some encoding issue (UTF-8).
* New CLI option for max number of crawled URLs.

## Development

Currently this is only a personal learning project.

## Contributing

No need at the moment, thanks.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

