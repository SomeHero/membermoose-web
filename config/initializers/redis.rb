if Rails.env == 'production'
  #puts REDISTO_GO_URL
  REDIS = Redis.new(url: ENV["REDIS_URL"])
  Resque.redis = REDIS
end
