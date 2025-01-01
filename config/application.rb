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

    # Autoload models under lib
    # config.autoload_paths << Rails.root.join("lib","models")
    config.autoload_lib(ignore: %w(tasks))

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path << Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.default_locale = :en
    config.i18n.available_locales = [ :ar, :zh, :en, :fr, :ru, :es, :de, :se, :fi ]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    config.action_mailer.default_url_options = { host: "unitethearmies.org" }

    # config.before_configuration do
    #   env_file = File.join(Rails.root, 'config', 'local_env.yml')
    #   YAML.load(File.open(env_file)).each do |key, value|
    #     ENV[key.to_s] = value
    #   end if File.exists?(env_file)
    # end

    # https://guides.rubyonrails.org/configuring.html#custom-configuration
    config.x.admin_hash = ENV["UNITE_ADMIN_HASH"]

    # Mailer settings are empty if after_initialize block is used at production mode.
    #
    # config.after_initialize do
    #   domain = Rails.env.production? ? UNITE_DOMAIN_PRODUCTION : UNITE_DOMAIN_DEVELOPMENT
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              "smtp.gmail.com",
      port:                 587,
      domain:               "unitethearmies.org",
      user_name:            ENV["UNITE_GMAIL_USERNAME"],
      password:             ENV["UNITE_GOOGLE_APP_PASSWORD"],
      authentication:       "plain",
      enable_starttls:      true,
      open_timeout:         5,
      read_timeout:         5
    }

    config.filter_parameters += [:email_repeat]
    # config.force_ssl = true

  end


end
