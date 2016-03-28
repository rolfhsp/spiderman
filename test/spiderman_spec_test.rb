require 'test_helper'


describe Spiderman do

  describe "CLI" do

    describe "option -v" do
      it "should print the version number" do
        out, err = capture_io {::Spiderman::CLI::run(%w(-v))}
        out.chomp.must_equal "spiderman: version "+::Spiderman::VERSION
      end
    end

    describe "option -h" do
      it "should show usage information" do
        out, err = capture_io {::Spiderman::CLI::run(%w(-h))}
        out.chomp.must_include("Usage: spiderman")
      end
    end

    describe "option --url" do
      it "should not lack the URL argument" do
        out,err = capture_io {::Spiderman::CLI::run(%w(--url))}
        out.chomp.must_include("missing argument")
      end

      it "should not accept FTP URL" do
        out,err = capture_io {::Spiderman::CLI::run(%w(--url ftp://example.com))}
        out.chomp.must_include("only http/https URLs are supported")
      end

    end

    describe "invalid option" do
      it "should give a proper error message" do
        out, err = capture_io {::Spiderman::CLI::run(%w(-z))}
        out.chomp.must_include('invalid option')
      end
    end


  end
end

