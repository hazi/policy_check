# frozen_string_literal: true

require "simple_policy/version"
require "simple_policy/module_builder"

# extend this module to add `.policy` method
#
# @example inline policy
#   class Post
#     extend SimplePolicy #-> only add `.policy` method
#
#     policy :publishable do #-> only create `#publishable?` and `#publishable_errors` method
#       error 'status is not draft', &:not_draft?
#       error('body is empty') { @body.empty? }
#     end
#   end
#
# @example policy class
#   class Post
#     extend SimplePolicy #-> only add `.policy` method
#
#     policy do #-> only create `#valid?`, `#invalid?` and `#error_messages` method
#       error 'status is not draft', &:not_draft?
#       error('body is empty') { @body.empty? }
#     end
#   end
module SimplePolicy
  # @param [#to_sym] name policy name, default is `nil`.
  #   If a name is specified "#{name}?" and "#{name}_errors" method are added.
  #   if `nil`, add `#error_messages`, `#valid?` and `#invalid?` method
  def policy(name = nil, &block)
    name = name&.to_sym
    class_exec { include SimplePolicy::ModuleBuilder.new(name, &block) }
  end
end
