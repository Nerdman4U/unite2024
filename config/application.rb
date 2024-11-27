require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UniteTheArmiesOrg
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    #config.i18n.default_locale = :en

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    config.action_mailer.default_url_options = { host: 'unite-the-armies.org' }

    # config.before_configuration do
    #   env_file = File.join(Rails.root, 'config', 'local_env.yml')
    #   YAML.load(File.open(env_file)).each do |key, value|
    #     ENV[key.to_s] = value
    #   end if File.exists?(env_file)
    # end

    config.admin_hash = "26d438f70627d0a01a9435d3675a6902"
    #config.unite_google_app_password = ENV["UNITE_GOOGLE_APP_PASSWORD"]

    config.after_initialize do
      domain = Rails.env.production? ? UNITE_DOMAIN_DEVELOPMENT : UNITE_DOMAIN_PRODUCTION
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        address:              'smtp.gmail.com',
        port:                 587,
        domain:               domain,
        user_name:            ENV["UNITE_GMAIL_USERNAME"],
        password:             ENV["UNITE_GOOGLE_APP_PASSWORD"],
        authentication:       'plain',
        enable_starttls_auto: true
      }
    end

  end
end
