# frozen_string_literal: true

require "simple_policy/error_list"

module SimplePolicy
  # Module Builder to define methods to make decisions
  class ModuleBuilder < Module
    def initialize(name, &block) # rubocop:disable Lint/MissingSuper
      define_method "#{name}?" do
        errors = ErrorList.new(self, &block)
        errors.valid?
      end

      define_method "#{name}_errors" do
        errors = ErrorList.new(self, &block)
        errors.error_messages
      end
    end
  end
end
