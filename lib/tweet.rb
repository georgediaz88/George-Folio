module TwitterMethods
  class Tweet
    def self.remove!(status_id, usr_id)
      redis_tweets = $redis.lrange 'my_tweets', 0, -1
      redis_tweets.each do |tweet|
        if tweet.include?(status_id.to_s)
          $redis.lrem 'my_tweets', 1, tweet
        end
      end
    end
  end

  def fetch_tweets_if_needed
    if $redis.llen('my_tweets') < 2 or $redis.llen('my_tweets') > 10 #reload tweets
      $redis.del 'my_tweets'
      tweets = Twitter.user_timeline(count: 2)
      tweets.reverse.each do |tweet| 
        $redis.lpush 'my_tweets', "#{tweet.text}PipeTweetPipe#{tweet.source}PipeTweetPipe#{tweet.id}"
      end # $redis.expire 'my_tweets', 60*15
    end
  end

  def parse_from_redis(tweet_objects)
    tweet_objects.each do |tweet_obj|
      parsed_tweet = tweet_obj.split('PipeTweetPipe')
      text, source = parsed_tweet[0], parsed_tweet[1]
      @latest_tweets << {text: text, source: source}
    end
  end
end