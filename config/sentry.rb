Sentry.init do |config|
  config.dsn = 'https://f561f774715fa32c471f157e414a824b@o4507410904776704.ingest.us.sentry.io/4507410907070464'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  config.traces_sample_rate = 1.0
  config.profiles_sample_rate = 1.0
end
