# frozen_string_literal: true

require "policy_check/error"

module PolicyCheck
  # A model that summarizes the errors defined in the {PolicyCheck#policy} block
  class ErrorList
    def initialize(model, &block)
      @model = model
      @block = block
      @errors = []
      instance_eval(&block)
    end

    # @return [Boolean] true if all errors are false
    def valid?
      errors.none?(&:error?)
    end

    # @return [Array<String>] error messages
    def error_messages
      errors.map(&:error_message).compact
    end

    private

    attr_reader :model, :block, :errors

    # called when a policy is defined
    def error(message, &block)
      @errors << Error.new(model, message, &block)
    end
  end
end
