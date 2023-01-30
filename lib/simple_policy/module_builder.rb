# frozen_string_literal: true

require "simple_policy/error_list"

module SimplePolicy
  # Module Builder to define methods to make decisions
  class ModuleBuilder < Module
    def initialize(name, &block) # rubocop:disable Lint/MissingSuper, Metrics/MethodLength
      define_method name ? "#{name}?" : "valid?" do
        errors = ErrorList.new(self, &block)
        errors.valid?
      end

      if name.nil?
        define_method "invalid?" do
          errors = ErrorList.new(self, &block)
          !errors.valid?
        end
      end

      define_method name ? "#{name}_errors" : "error_messages" do
        errors = ErrorList.new(self, &block)
        errors.error_messages
      end
    end
  end
end
