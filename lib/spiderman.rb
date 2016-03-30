require "spiderman/version"
require "spiderman/crawler"
require "spiderman/scraper"
require "spiderman/cli"

# Namespace for the Spiderman application
module Spiderman
  
  # The application name
  APPNAME = "spiderman"

  # Create a 10 character digest
  def self.digest10(text)
    Digest::SHA256.hexdigest(text)[0..9]
  end

end


