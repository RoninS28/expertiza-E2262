# frozen_string_literal: true

ActionController::ForceSSL::ClassMethods.module_eval do
  def force_ssl(options = {})
    config = Rails.application.config

    return unless config.use_ssl # <= this is new

    host = options.delete(:host)
    if config.respond_to?(:ssl_port) && config.ssl_port.present?
      port = config.ssl_port
    end # <= this is also new

    before_action(options) do
      unless request.ssl? # && !Rails.env.development? # commented out the exclusion of the development environment
        redirect_options = { protocol: 'https://', status: :moved_permanently }
        redirect_options.merge!(host: host) if host
        redirect_options.merge!(port: port) if port # <= this is also new
        redirect_options.merge!(params: request.query_parameters)
        redirect_to redirect_options
      end
    end
  end
end
