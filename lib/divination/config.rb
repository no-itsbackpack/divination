require 'active_support/configurable'

module Divination
  # Configures global settings for Divination
  #   Divination.configure do |config|
  #     config.default_per_page = 10
  #   end
  def self.configure(&block)
    yield @config ||= Divination::Configuration.new
  end

  # Global settings for Divination
  def self.config
    @config
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :default_per_page
    config_accessor :max_per_page
    config_accessor :min_id
    config_accessor :max_id

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    end
  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.default_per_page = 25
    config.max_per_page = nil
    # config.min_id
    # config.max_id
  end
end
