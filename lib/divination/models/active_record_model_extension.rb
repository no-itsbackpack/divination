module Divination
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      self.send(:include, Divination::ConfigurationMethods)

      # Fetch the values at the specified page edge
      #   Model.page(after: 5)
      def self.page(options = {})
        collection(options[:max_id]).
        descending.
        limit(default_per_page).extending do
          include Divination::PageScopeMethods
        end
      end

      def self.collection(max_id)
        if max_id.nil?
          where(nil)
        else
          where(["#{self.table_name}.#{primary_key} <= ?", max_id])
        end
      end

      def self.descending
        reorder("#{self.table_name}.#{primary_key} desc")
      end

      def self.primary_key
        super || 'id'
      end
    end
  end
end
