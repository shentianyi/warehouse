require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Warehouse
  class Application < Rails::Application
    #config.paths['config/database']='config/wangsong_database.yml' if ENV['USER']=='wangsong'
    #config.paths['config/database']='config/charlot_database.yml' if ENV['USER']=='charlot'
   # config.paths['config/database']='config/mac_database.yml' if ENV['USER']=='liqi'
    #config.paths['config/database']='config/mac_database.yml' if ENV['USER']=='exmooncake'
    config.paths['config/database']='config/mac_database.yml' if /darwin\w+/.match(RbConfig::CONFIG['host_os'])
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    # for the api
    %w{models api service presenters caches}.each do |namespace|
      config.paths.add File.join('app', namespace), glob: File.join('**', '*.rb')
      config.autoload_paths += Dir[Rails.root.join('app', namespace, '**')]
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.middleware.use ActionDispatch::Flash
    I18n.enforce_available_locales = false
    #config.cache_store = :redis_store, $redis
    #config.action_dispatch.default_headers.merge!({
    #                                                  'Access-Control-Allow-Origin' => '*',
    #                                                  'Access-Control-Request-Method' => '*'
    #                                              })
  end
end
