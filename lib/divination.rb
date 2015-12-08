require "divination/version"

module Divination
end

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
  #do nothing
end

# load Divination components
require 'divination/config'
require 'divination/models/page_scope_methods'
require 'divination/models/configuration_methods'
require 'divination/hooks'

# if not using Railtie, call `Divination::Hooks.init` directly
if defined? Rails
  require 'divination/railtie'
  require 'divination/engine'
end
