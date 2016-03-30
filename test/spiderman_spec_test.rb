require 'test_helper'


describe Spiderman do

  describe "CLI" do

    before do
      @cli = Spiderman::CLI.new()
      @opts = nil
    end

    describe "option -v" do
      it "should print the version number" do
        out, err = capture_io {@cli.parse_options(%w(-v))}
        out.chomp.must_equal "spiderman: version "+::Spiderman::VERSION
      end
    end

    describe "option -h" do
      it "should show usage information" do
        out, err = capture_io {@cli.parse_options(%w(-h))}
        out.chomp.must_include("Usage: spiderman")
      end
    end

    describe "option --url" do
      it "should set the base_url_string option" do
        out,err = capture_io {@opts = @cli.parse_options(%w(--url http://www.example.com))}
        @opts.must_include(:base_url_string)
        @opts[:base_url_string].must_equal("http://www.example.com")
      end

      it "should not lack the URL argument" do
        out,err = capture_io {@cli.parse_options(%w(--url))}
        out.chomp.must_include("missing argument")
      end

      it "should not accept FTP URL" do
        out,err = capture_io {@cli.parse_options(%w(--url ftp://example.com))}
        out.chomp.must_include("invalid argument")
      end
    end

    describe "option --site" do
      it "should set the site_only option" do
        out,err = capture_io {@opts = @cli.parse_options(%w(--site))}
        @opts[:site_only].must_equal(true)
      end
    end


    describe "option --depth" do
      it "should set the max_crawl_depth option" do
        out,err = capture_io {@opts = @cli.parse_options(%w(--depth 10))}
        @opts[:max_crawl_depth].must_equal(10)
      end
    end

    describe "option --urls" do
      it "should set the max_urls option" do
        out,err = capture_io {@opts = @cli.parse_options(%w(--urls 1000))}
        @opts[:max_urls].must_equal(1000)
      end
    end

    describe "option --verbose" do
      it "should set the verbose flag" do
        out, err = capture_io {@opts = @cli.parse_options(%w(--verbose))}
        @opts.must_include(:verbose)
        @opts[:verbose].must_equal(true)
      end
    end

    describe "invalid option" do
      it "should give a proper error message" do
        out, err = capture_io {@cli.parse_options(%w(-z))}
        out.chomp.must_include('invalid option')
      end
    end


  end
end

