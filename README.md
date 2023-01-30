# SimplePolicy

SimplePolicy provides a DSL for policy definitions and allows you to get reasons for policy violations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_policy', github: 'hazi/simple_policy'
```

And then execute:

    $ bundle


## Usage

### Inline policy

```ruby
class Post
  extend SimplePolicy #-> only add `.policy` method

  def initialize
    @status = :draft
    @body = ""
  end

  def not_draft?
    @status != :draft
  end

  policy :publishable do #-> only create `#publishable?` and `#publishable_errors` method
    error "status is not draft", &:not_draft?
    error("body is empty") { @body.empty? }
  end

  def publish!
    fail publishable_errors.join(", ") unless publishable?
    publish
  end
end

post = Post.new
post.publishable_errors #=> ["body is empty"]
post.publishable? #=> false
```

### Policy class

```ruby
class PostPublishablePolicy
  extend SimplePolicy #-> only add `.policy`

  def initialize(post, user)
    @post = post
    @user = user
  end
  attr_reader :post, :user

  def not_admin?
    !user.admin?
  end

  policy do #-> only create `#valid?` and `#error_messages` method
    error "user is not admin", &:not_admin?
    error("status is not `draft`") { post.status != :draft }
    error("body is empty") { post.body.empty? }
  end
end

post = Post.find(1)
user = current_user
PostPublishablePolicy.new(post, user).error_messages #=> ["body is empty", "write is not admin"]
PostPublishablePolicy.new(post, user).valid? #=> false
PostPublishablePolicy.new(post, user).invalid? #=> true
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
