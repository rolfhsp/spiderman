module Spiderman


  ##
  # The Scraper searches and collects rexexp matches in a text
  class Scraper

    # Regexp definition for discovering simple URLs for 
    VALID_URL = /https?:\/\/.[^\\#?:"();:*,'`'<>\[\]\s]*/

    # Constructor stores the text that will be scraped
    def initialize(text)
      @text = text
    end

    # Scrape text with given search term (regular expression)
    def scrape(regexp)
      @text.scan(regexp)
    end

    # Scrape text for urls.
    # If given a url_string, only urls matching this base url should be scraped.
    def scrape_url(url_string = nil)
      if (url_string)
        url_regexp = /#{url_string}[^\\#?:"();:*,'`'<>\[\]\s]*/
      else
        url_regexp = VALID_URL
      end
      scrape(url_regexp).map!{|url| url.chomp("/")}
    end

  end
end





