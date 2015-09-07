ENV["REDISTOGO_URL"] ||= "redis://username:password@host:1234/"

REDIS = Redis.new(url: ENV["REDIS_URL"])
Resque.redis = REDIS
