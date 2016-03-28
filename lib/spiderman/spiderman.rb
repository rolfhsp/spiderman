# Some common methods

require 'digest'
require 'uri'

module Spiderman

  VALID_URL_RE = /\A#{URI::regexp(['http', 'https'])}\z/ 

  # Create a 10 character digest
  def self.digest10(text)
    Digest::SHA256.hexdigest(text)[0..9]
  end

end

