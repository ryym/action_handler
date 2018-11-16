# Action Handler

[![CircleCI](https://circleci.com/gh/ryym/action_handler.svg?style=svg)](https://circleci.com/gh/ryym/action_handler)

ActionHandler is a Rails plugin that helps you write controller functionalities in clean and testable way.

## What is a handler?

A handler is a controller-like class. Each public method can be an action method.
But unlike controllers, handlers inherit few methods by default.
Instead of using super class methods such as `params`, `sessions`, you can take them as arguments.
And you need to represent a response (data for views) as a single return value,
instead of assigning multiple instance variables.

```ruby
# Example
class UsersHandler
  include ActionHandler::Equip # (optional)

  def initialize(ranking: RankingService.new)
    @ranking = ranking
  end

  # Get request information via arguments.
  def index(params, cookies)
    puts "cookies: #{cookies}"

    users = User.order(:id).page(params[:page])
    ranks = @ranking.generate(users)

    # Return a hash. It will be passed to controller's `render`.
    { locals: { users: users, ranks: ranks } }
  end

  # Define custom argument.
  arg(:user_id) do |ctrl|
    ctrl.params[:id]
  end

  def show(user_id, format)
    user = User.find(user_id)

    # `render` is available as well. It just returns a given hash.
    if format == :html
      render locals: { user: user }
    else
      render json: user
    end
  end

  # ...
end
```

## Features

### Clean and clear structure

- In handlers, action methods take necessary inputs as arguments and represent output as a return value.
  So easy to read and test.
- Handler is just a class, so you can set up any dependencies via `initialize` method.

### Automatic arguments injection

- ActionHandler automatically injects common controller properties (`params`, `request`, etc)
  just by declaring them as action method's arguments.
- You can define custom injectable arguments as well.

This feature is heavily inspired by [ActionArgs](https://github.com/asakusarb/action_args).

## Motivation

- Testability is important as much or more than test itself.
- Prefer clarity and simplicity over code shortness and easiness, for future maintainability.

## Getting Started

Installation:

```bash
gem install action_handler
```

A simplest handler is a plain class with no super classes.

```ruby
class UsersHandler
  def index(params)
    users = User.order(:id).page(params[:page])
    { locals: { users: users } }
  end

  def show(params)
    user = User.find(params[:id])
    { locals: { user: user } }
  end
end
```

To use this handler, register it in a controller.

```ruby
class UsersController < ApplicationController
  include ActionHandler::Controller

  use_handler { UsersHandler.new }
end
```

This makes the controller implement same name action methods.
Now you can define routes to this controller as usual.

```ruby
resources :users, only: %i[index show]
```


Though you can use plain handler classes, usually you need to include `ActionHandler::Equip` module
to use basic controller functionalities like `redirect_to` or custom arguments.

## Guides

- [Detail guides][wiki]
- [Example Rails app][example]

[wiki]: https://github.com/ryym/action_handler/wiki
[example]: https://github.com/ryym/action_handler/tree/master/examples/sample
