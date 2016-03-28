require 'optparse'
require 'ostruct'
require 'spiderman/version'
require 'pp'

module Spiderman

  # Namespace for the Spiderman Command Line Interface
  module CLI

    # Parse the command line options
    def self.parse_options(args)
      
      options = OpenStruct.new

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: spiderman [options]'
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("--url URL", "Starting URL") do |url|
          if url !~ VALID_URL_RE
            raise OptionParser::InvalidArgument, "only http/https URLs are supported"
          end
          options.url = url
        end

        opts.separator ""
        opts.separator "Common options:"


        opts.on_tail('--help', '-h', 'Show this message') do
          puts opts
          return
        end

        opts.on_tail('--version', '-v', 'Show version') do
          puts "#{APPNAME}: version #{VERSION}"
          return
        end
      end

      begin
        opt_parser.parse!(args)
      rescue OptionParser::ParseError => ex
        puts ex
      end

      options
    end

    # Provide an interface for both the bin/spiderman executable and
    # for the test suite
    def self.run(args)
      options = parse_options(args)
    end
  end

end

