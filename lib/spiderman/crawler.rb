# Some common methods

require 'digest'
require 'open-uri'
require 'timeout'

module Spiderman

  ## 
  # The crawler uses three lists to keep track of discovered URLs
  # @crawled_urls: URLs which has successfully been crawled/scraped
  # @queued_urls:  URLs discovered in the crawled/scraped URLs.
  # @failed_urls:  URLs which has failed to be crawled/scraped due to misc.
  #                reasons such as timeout or not having correct content type.
  class Crawler 

    # Default options to be used if not supplied in the constructor call
    DEFAULT_OPTS = {
      base_url_string: "http://www.example.com",
      site_only: false,       # Crawl only one site or follow external links
      max_crawl_depth: 1,     # Maximum depth of search
      max_urls: 10000,        # Maximum number of discovered URLs
      verbose: false          # Verbose mode produces more info on screen
    }


    # Constructor takes the base url from which to start the web crawling
    def initialize( opts={} )

      puts "#{self.class}#{__method__}: Default opts:  #{DEFAULT_OPTS}" if opts[:verbose]
      puts "#{self.class}#{__method__}: Supplied opts: #{opts}" if opts[:verbose]
      @opts = DEFAULT_OPTS
      @opts.merge!(opts)
      puts "#{self.class}#{__method__}: Merged opts:   #{@opts}" if opts[:verbose]

      # Use a digest of the base url string for identifying the search,
      # e.g. in a file name or dataase index.
      @base_url_string = @opts[:base_url_string]
      @base_url_id = Spiderman::digest10(@base_url_string)

      # Create two hashes, one for the queued urls that will be crawled/scraped
      # later, and one for the already crawled/scraped urls
      # The hash key should be the url name digest, and value should be an
      # array with the following structure
      # [ url, crawl_depth, status ]
      @queued_urls = Hash.new
      @crawled_urls = Hash.new
      @failed_urls = Hash.new
      @n_discovered_urls = 0

    end

    # Checks if url has already been crawled
    def url_crawled?(url_id)
      @crawled_urls.include?(url_id)
    end

    # Checks if url has already been added to queue
    def url_queued?(url_id)
      @queued_urls.include?(url_id)
    end

    # Checks if url has been tried and failed
    def url_failed?(url_id)
      @failed_urls.include?(url_id)
    end

    # Check if url has been discovered before
    def url_discovered?(url_id)
      url_crawled?(url_id) || url_queued?(url_id) || url_failed?(url_id)
    end

    # Adds a url to the hash of queued urls
    # Does not add the url if
    #   * crawl_depth has exeeded max crawl depth + 1 (allowed to scrape and store links for next level)
    #   * url is already in queue
    #   * url is already crawled
    #   * url has been tried and failed
    #
    #   Returns truthy if added to queue
    def queue_url(url_id, url_string, crawl_depth)
      return if (crawl_depth > @opts[:max_crawl_depth]+1 ||
                 @n_discovered_urls >= @opts[:max_urls] ||
                 url_discovered?(url_id) )

      @n_discovered_urls += 1
      @queued_urls[url_id] = {url_string: url_string, crawl_depth: crawl_depth}
      puts "#{url_id}, #{crawl_depth}, #{@n_discovered_urls}, #{@queued_urls.size}, #{@crawled_urls.size}, #{@failed_urls.size}, #{url_string}"
    end

    # Add url to the crawled url list
    def add_crawled_url (url_id, url_data)
      puts "#{url_id} Crawled" if @opts[:verbose]
      @crawled_urls[url_id] = url_data
    end

    # Add url to the failed url list
    def add_failed_url (url_id, url_data)
      puts "#{url_id} Failed" if @opts[:verbose]
      @failed_urls[url_id] = url_data
    end

    # Fetche the next queued URL dataset, or nil if empty queue
    # The Hash#first method, returns a two element array with the
    # Hash key (URL digest) and the Hash value (url, crawl_depth ...)
    # Do not get it if it's crawl depth is > max crawl depth
    def get_next_url_from_queue
      next_url = @queued_urls.first 
      return nil if next_url[1][:crawl_depth] > @opts[:max_crawl_depth]
      next_url
    end

    # Initiate the web crawl
    def crawl

      # Recover from any previously aborted search here
      # ...
      # 


      # Start with queueing the base URL
      queue_url(@base_url_id, @base_url_string, 1)

      while (@n_discovered_urls < @opts[:max_urls] &&
             (url = get_next_url_from_queue) )

        url_id, url_data = url
        if (@opts[:verbose])
          puts "#{url_id} Crawling - [#{url_data[:crawl_depth]},#{@n_discovered_urls}] - [#{@crawled_urls.size},#{@queued_urls.size},#{@failed_urls.size}] - #{url_data[:url_string]}"
        end

        page, text = nil
        begin
          timeout(2) do
            page = open(url_data[:url_string])

            if ( page && @opts[:verbose] )
              puts "Content type: #{page.content_type}"
            end

            if page.content_type == "text/html"
              text = page.read
            end
          end
        rescue => ex
          url_data[:failed]=ex.inspect
          puts ex.inspect if @opts[:verbose]
        end

        # text is nil if something went wrong,
        # or if page content type is not text/html
        if (!url_data[:failed] && text)
          scraper = Scraper.new(text) 

          # This part may throw some exceptions, e.g. based on
          # encoding issues. Handle with care. For now, just handle
          # all exceptions as failed URLs.
          begin
            # Scrape text for misc data for analysis
            # ...

            # Scrape text for urls and add to queue
            # If the site_onlly option is true, supply the base url
            if (@opts[:site_only])
              url_strings = scraper.scrape_url(@base_url_string)
            else
              url_strings = scraper.scrape_url()
            end
            url_strings.each do |url_string|
              queue_url(Spiderman::digest10(url_string),
                      url_string, url_data[:crawl_depth]+1)
            end

          rescue  => ex
            url_data[:failed]=ex.inspect
            puts ex.inspect if @opts[:verbose]
          end

        end

        if url_data[:failed]
          # Consider URL failed, and add to failed URL list.
          add_failed_url(url_id, url_data)
        else
          # Consider URL successfully crawled, and add to crawled URL list.
          add_crawled_url(url_id, url_data)
        end

        # Remove the url from the queued urls list
        @queued_urls.delete(url_id)
      end
    end

  end
end

