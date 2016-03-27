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
      options.library = []
      options.inplace = false
      options.encoding = :utf8
      options.transfer_type = :auto
      options.verbose = false

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: spiderman [options] [URL]'
        opts.separator ""
        opts.separator "Specific options:"

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
      rescue OptionParser::InvalidOption => ex
        puts "Invalid option(s) given: #{ex.args}"
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

