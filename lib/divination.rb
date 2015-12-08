require "divination/version"

module Divination
end

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
  #do nothing
end

# load Cursor components
require 'divination/config'
require 'divination/models/page_scope_methods'
require 'divination/models/configuration_methods'
require 'divination/hooks'

# if not using Railtie, call `Cursor::Hooks.init` directly
if defined? Rails
  require 'cursor/railtie'
  require 'cursor/engine'
end
