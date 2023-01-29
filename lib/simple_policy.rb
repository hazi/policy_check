# frozen_string_literal: true

require "simple_policy/version"
require "simple_policy/module_builder"

# @example
#   class Post
#     extend SimplePolicy #-> only add `.policy` method
#
#     def initialize
#       @status = :draft
#       @body = ""
#     end
#
#     def not_draft?
#       @status != :draft
#     end
#
#     policy :publishable do #-> only create `#publishable?` and `#publishable_errors` method
#       error 'status is not draft', &:not_draft?
#       error('body is empty') { @body.empty? }
#     end
#
#     def publish!
#       fail publishable_errors.join(", ") unless publishable?
#       publish
#     end
#   end
#
#   post = Post.new
#   post.publishable_errors #=> ['body is empty']
#   post.publishable? #=> false
module SimplePolicy
  def policy(name, &block)
    name = name.to_sym
    class_exec { include SimplePolicy::ModuleBuilder.new(name, &block) }
  end
end
