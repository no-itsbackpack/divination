module Divination
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'divination' do |_app|
      Divination::Hooks.init
    end
  end
end
