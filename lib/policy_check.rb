# frozen_string_literal: true

require "policy_check/version"
require "policy_check/module_builder"

# extend this module to add `.policy` method
#
# @example inline policy
#   class Post
#     extend PolicyCheck #-> only add `.policy` method
#
#     policy :publishable do #-> only create `#publishable?` and `#publishable_errors` method
#       error 'status is not draft', &:not_draft?
#       error('body is empty') { @body.empty? }
#     end
#   end
#
# @example policy class
#   class Post
#     extend PolicyCheck #-> only add `.policy` method
#
#     policy do #-> only create `#valid?`, `#invalid?` and `#error_messages` method
#       error 'status is not draft', &:not_draft?
#       error('body is empty') { @body.empty? }
#     end
#   end
module PolicyCheck
  # If a name is specified "#\\{name}?" and "#\\{name}_errors" method are added.
  # if name is `nil`, add `#error_messages`, `#valid?` and `#invalid?` method
  # @param [#to_sym] name policy name, default is `nil`.
  def policy(name = nil, &block)
    name = name&.to_sym
    class_exec { include PolicyCheck::ModuleBuilder.new(name, &block) }
  end
end
