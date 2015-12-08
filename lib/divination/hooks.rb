module Divination
  class Hooks
    def self.init
      ActiveSupport.on_load(:active_record) do
        require 'divination/models/active_record_extension'
        ::ActiveRecord::Base.send :include, Divination::ActiveRecordExtension
      end
    end
  end
end
