require 'cosmicrawler'
require 'nokogiri'
require 'uri'
require 'logger'
require 'open-uri'

if ARGV.empty?
  puts 'Pass file name in the 1st parameter.'
  exit
end


file = ARGV[0]

urls = File.open(file).read.split("\n")


result = {}


r = Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)     


logger = Logger.new(STDOUT)



Cosmicrawler.http_crawl(urls, 16) {|request|

  begin
    uri = request.uri
    logger.info(uri)

    # init result hash
    result[uri] = []

    response = request.get.response


    # find next pages
    next_page_url = []
    doc = Nokogiri::HTML(response)
    doc.css('a').each do |anchor|
      path =  anchor[:href]
      next unless path
      next if path.match(/mailto/)
      next if path.match(/\.pdf\Z/)
      next_page_url <<  URI.join(uri, path).to_s
    end

    # get email address
    emails = response.scan(r).uniq

    result[uri].concat(emails)
    logger.debug(emails)

    next_page_url.uniq!

    return unless next_page_url
    #
    next_page_url.each do |url|

      logger.info(url)

      response = open(url).read

      emails = response.scan(r).uniq
      result[uri].concat(emails)

      logger.debug(emails)

    end


  rescue => e
    logger.error(e)
  end

}



result.each do |key, value|
  print key
  print "\t"
  print value.uniq.join("\t")
  print "\n"
end

