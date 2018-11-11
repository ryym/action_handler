require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sample
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.autoload_paths << Rails.root.join('app/services')

    # Autoload the library.
    config.autoload_paths << Rails.root.join('../../lib')

    if Rails.env.development?
      config.to_prepare do
        Object.class_eval { remove_const :ActionHandler if defined? ActionHandler }
      end
    end

    config.generators.assets = false
    config.generators.helper = false
  end
end
