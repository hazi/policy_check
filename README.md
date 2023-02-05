[![test](https://github.com/hazi/policy_check/actions/workflows/test.yml/badge.svg)](https://github.com/hazi/policy_check/actions/workflows/test.yml) [![lint](https://github.com/hazi/policy_check/actions/workflows/lint.yml/badge.svg)](https://github.com/hazi/policy_check/actions/workflows/lint.yml)

# PolicyCheck

DSL for policy definitions and allows get reasons for policy violations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'policy_check'
```

And then execute:

    $ bundle


## Usage

```ruby
class Post
  extend PolicyCheck #-> only add `.policy` method
end
```

## Example

### Inline policy

```ruby
class Post
  extend PolicyCheck

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
  extend PolicyCheck

  def initialize(post, user)
    @post = post
    @user = user
  end
  attr_reader :post, :user

  def not_admin?
    !user.admin?
  end

  policy do #-> only create `#valid?`, `#invalid?` and `#error_messages` method
    error "user is not admin", &:not_admin?
    error("status is not `draft`") { post.status != :draft }
    error("body is empty") { post.body.empty? }
  end
end

post = Post.find(1)
user = current_user
PostPublishablePolicy.new(post, user).error_messages #=> ["body is empty", "user is not admin"]
PostPublishablePolicy.new(post, user).valid? #=> false
PostPublishablePolicy.new(post, user).invalid? #=> true
```

## Compatibility

PolicyCheck officially supports the following runtime Ruby implementations:

- MRI 2.7, 3.0, 3.1, 3.2

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bundle exec rspec` to run the tests.
Before committing, run `bundle exec rubocop` to perform a style check.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contribution

1. Fork it ( https://github.com/hazi/policy_check/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
