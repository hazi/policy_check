# frozen_string_literal: true

module SimplePolicy
  # Determines the error
  class Error
    def initialize(model, message, &block)
      @model = model
      @block = block
      @message = message
    end
    attr_reader :model, :message

    def error?
      model.instance_eval(&@block)
    end

    def error_message
      error? ? message : nil
    end
  end
end
