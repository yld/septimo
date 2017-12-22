# frozen_string_literal: true

unless Rails.env.test?
  require 'flamegraph'
  require 'rack-mini-profiler'
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.position = 'right'
  Rack::MiniProfiler.config.skip_schema_queries = true

  # set MemoryStore
	Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore

	# set RedisStore and overide MemoryStore in production
	if Rails.env.production? && ENV.key?('REDIS_SERVER_URL')
		uri = URI.parse(ENV['REDIS_SERVER_URL'])
		Rack::MiniProfiler.config.storage_options = { :host => uri.host, :port => uri.port, :password => uri.password }
		Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
	end
end
