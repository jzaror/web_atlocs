ENV["REDIS_URL"] ||= "redis://10.128.0.4:6379"

REDIS = Redis.new(url: ENV["REDIS_URL"])
