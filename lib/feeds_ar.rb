require "rubygems"
require "activerecord"

ActiveRecord::Base.establish_connection(
  :adapter => "jdbcmysql",
  :host => "localhost",
  :database => "rss_news_reader_dev",
  :username => "root"
)

class Feed < ActiveRecord::Base
end

feed = Feed.find(1)
puts "Found feed with id => #{feed.id}: #{feed.uri}, #{feed.title_xpath}"
