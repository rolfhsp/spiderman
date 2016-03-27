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

    describe "invalid option" do
      it "should give a proper error message" do
        out, err = capture_io {::Spiderman::CLI::run(%w(-z))}
        out.chomp.must_equal('Invalid option(s) given: ["-z"]')
      end
    end


  end
end

