ENV["REDIS_URL"]="redis://localhost:6379" if Rails.env.development?
ENV["REDIS_URL"]="redis://"+ENV["REDIS_PORT_6379_TCP_ADDR"]+":"+ENV["REDIS_PORT_6379_TCP_PORT"] if ENV["REDIS_PORT_6379_TCP_ADDR"]
puts "REDIS is "+ENV["REDIS_URL"]
REDIS = Redis.new(url: ENV["REDIS_URL"])