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

#cnn_feed = Feed.new # Lab 2.0
cnn_feed = Feed.find_or_create_by_title("CNN Top Stories") # Lab 2.1
cnn_feed.title = "CNN Top Stories" # Lab 2.0
cnn_feed.uri = "http://rss.cnn.com/rss/cnn_topstories.rss"
cnn_feed.title_xpath = "//item/title"
cnn_feed.save

#fox_feed = Feed.new # Lab 2.0
fox_feed = Feed.find_or_create_by_title("Fox News Latest") # Lab 2.1
fox_feed.title = "Fox News Latest" # Lab 2.0
fox_feed.uri = "http://feeds.foxnews.com/foxnews/latest"
fox_feed.title_xpath = "//item/title"
fox_feed.save

["CNN Top Stories", "Fox News Latest"].each do |title|
  feed = Feed.find_by_title(title)
  puts "Found feed with id => #{feed.id}: #{feed.uri}, #{feed.title_xpath}"
end

