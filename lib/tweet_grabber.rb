#!/usr/bin/env ruby

require 'logger'
require 'tweetstream'
require 'smarter_csv'
require 'mongo'

## Config Variables ##

# Twitter config
twitter_consumer_key = ""
twitter_consumer_secret = ""
twitter_oauth_token = ""
twitter_oauth_token_secret = ""

# MongoDB config
db_to_use = ""                          # Example: tweet_database
collection_to_use = ""                  # Example: tweets
mongo_replicaset_members = ['','']      # Example: ['192.168.1.2:27017', '192.168.1.3:27017', '192.168.1.4:27017']

# CSV file
csv_of_tweeters = ""                    # Include the full path here

# Log file to store all the tweets
log_file = ""                           # Include the full path here


## METHODS ##

# Save a tweet to the database
def save_a_tweet(collection, logger, status)
  tries ||= 3
  collection.insert(status.attrs)
rescue Exception => e
  tries -= 1
  if tries > 0
    sleep(5)
    retry
  else
    logger.info("Failed to add the tweet: #{e}")
  end
else
  logger.info("Tweet added: @#{status.user.screen_name}: #{status.text}")
end

## ACTION ##

# Set up the app logging
logger = Logger.new(log_file)
logger.level = Logger::INFO

# Let's start the engines!
logger.info("Starting the engines...")

# Set up the TweetStream configuration
logger.info("Setting up the connection to Twitter")
TweetStream.configure do |config|
  config.consumer_key       = twitter_consumer_key
  config.consumer_secret    = twitter_consumer_secret
  config.oauth_token        = twitter_oauth_token
  config.oauth_token_secret = twitter_oauth_token_secret
  config.auth_method        = :oauth
end

# Create an array from our csv of accounts to follow
logger.info("Opening our CSV file of accounts to follow")
users_to_follow = []
follow_list = SmarterCSV.process(csv_of_tweeters)
follow_list.each do |tweeter|
  users_to_follow << tweeter[:twitter_account_id].to_s
end

# Connect to MongoDB for tweet insertion
logger.info("Connecting to MongoDB")
begin
  db_connect_attempts ||= 3
  db_client = Mongo::MongoReplicaSetClient.new(mongo_replicaset_members)
  db = db_client[db_to_use]
  tweet_collection   = db[collection_to_use]
rescue Exception => e
  db_connect_attempts -= 1
  if db_connect_attempts > 0
    sleep(15)
    retry
  else
    logger.info("Failed to connect to MongoDB: #{e}")
  end
end

# Connect to Twitter and start saving tweets
logger.info("Connecting to Twitter and starting to gather tweets")
begin
  twitter_connect_attempts ||= 3
  tweet_client = TweetStream::Client.new.follow(users_to_follow) do |status|
    save_a_tweet(tweet_collection, logger, status)
  end
rescue Interrupt => e
  logger.info("Shutdown requested")
  logger.info("Closing the connection to Twitter")
  logger.info("Closing the connection to MongoDB")
  db_client.close()
  logger.info("Shutdown complete. Have a great day!")
rescue Exception => e
  twitter_connect_attempts -= 1
  if twitter_connect_attempts > 0
    sleep(15)
    retry
  else
    logger.info("Failed to connect to Twitter: #{e}")
  end
end

# Crash Logger
at_exit do
  if $!
    open("./logs/tweetgrabber_crashes.log", 'a') do |log|
      error = {
        :timestamp => Time.now,
        :message => $!.message,
        :backtrace => $!.backtrace
      }
      YAML.dump(error, log)
    end
  end
end