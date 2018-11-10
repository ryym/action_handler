# Action Handler

```ruby
class UsersController < ApplicationController
  use_handler { UsersHandler.create }
end
```

```ruby
class UsersHandler
  include ActionHandler::Equip

  arg(:id) do |ctrl|
    ctrl.params[:id]
  end

  arg(:user_params) do |ctrl|
    ctrl.params.require(:user).permit(:id, :name, :age)
  end

  def self.create
    new(code_generator: UserCodeGenerator.create)
  end

  def initialize(code_generator:)
    @code_generator = code_generator
  end

  def index(params)
    users = User.order(:id).page(params[:page])
    render locals: { users: users }
  end

  def show(id, format)
    user = User.find(id)
    if format == :html
      render locals: { user: user }
    else
      render json: user.to_json
    end
  end

  def create(user_params, flash)
    user = User.new(user_params)
    user.code = @code_generator.generate(user)
    if user.save
      flash[:notice] = "created!"
      redirect_to urls.users_path
    else
      flash[:danger] = "error..."
      render locals: { user: user }
    end
  end
end
```
