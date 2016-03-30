require 'optparse'
require 'pp'

module Spiderman

  # Command Line Interface
  class CLI

    # Class constructor
    def initialize
      @end_program = false
    end

    # Parse the command line options using OptionParser from StdLib
    def parse_options(args)
      
      dopts = Spiderman::Crawler::DEFAULT_OPTS
      options = Hash.new

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: spiderman [options]'
        opts.separator ""
        opts.separator "Default values are given in parenthesis"
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("--url URL", "Setting the Base URL. (#{dopts[:base_url_string]})") do |url|
          if url !~ Spiderman::Scraper::VALID_URL
            raise OptionParser::InvalidArgument, "supports only http/https URLs"
          end
          options[:base_url_string] = url
        end

        opts.on("--site", "-s", "Crawl single site only. (#{dopts[:site_only]})") do
          options[:site_only] = true
        end

        opts.on("--depth N", "-d N", Numeric,  "Maximum crawl depth, counting the Base URL. (#{dopts[:max_crawl_depth]})") do |max_crawl_depth|
          if !(max_crawl_depth > 0)
            raise OptionParser::InvalidArgument, "supports only numbers > 0"
          end
          options[:max_crawl_depth] = max_crawl_depth
        end

        opts.on("--urls N", "-u N", Numeric, "Maximum number of urls to discover (#{dopts[:max_urls]})") do |max_urls|
          if !(max_urls > 0)
            raise OptionParser::InvalidArgument, "supports only numbers > 0"
          end
          options[:max_urls] = max_urls
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail('--verbose', "Verbose output. (#{dopts[:verbose]})") do
          options[:verbose] = true
        end

        opts.on_tail('--help', '-h', 'Show this message') do
          puts opts
          @end_program=true
          return
        end

        opts.on_tail('--version', '-v', 'Show version') do
          puts "#{APPNAME}: version #{VERSION}"
          @end_program=true
          return
        end
      end

      begin
        opt_parser.parse!(args)
      rescue => ex
        puts ex
        @end_program = true
      end

      options
    end

    # Parse the options and kick off the crawler
    def run(args)
      opts = parse_options(args)
      unless @end_program
        crawler = Spiderman::Crawler.new(opts)
        crawler.crawl
      end
    end
  end

end

