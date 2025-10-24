return unless defined?(Debugbar)

Debugbar.configure do |config|
  config.enabled = true if Rails.env.development?

  config.ignore_request = ->(env) do
    path = env['PATH_INFO'].to_s
    [
      Debugbar.config.prefix,
      "/assets",
      "/rails/active_storage"
    ].any? { |pfx| path.start_with?(pfx) }
  end
end