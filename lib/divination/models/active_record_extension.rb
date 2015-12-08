require 'divination/models/active_record_model_extension'

module Divination
  module ActiveRecordExtension
    extend ActiveSupport::Concern
    included do
      # Future subclasses will pick up the model extension
      class << self
        def inherited_with_divination(kls) #:nodoc:
          inherited_without_divination kls
          kls.send(:include, Divination::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
        end
        alias_method_chain :inherited, :divination
      end

      # Existing subclasses pick up the model extension as well
      self.descendants.each do |kls|
        kls.send(:include, Divination::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
      end
    end
  end
end
