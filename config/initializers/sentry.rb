Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  # enable performance monitoring
  config.enable_tracing = true
  # get breadcrumbs from logs
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
end if Rails.env.production?
