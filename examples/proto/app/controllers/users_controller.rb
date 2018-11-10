# frozen_string_literal: true

class UsersHandler
  include ActionHandler::Proto::Support

  def index
    users = User.all
    render locals: { users: users }
  end

  def show(params)
    user = User.find(params[:id])
    render locals: { user: user }
  end

  def new
    render locals: { user: User.new }
  end

  def create(params)
    user_params = params.require(:user).permit(:name)
    user = User.create!(user_params)
    redirect_to url_helpers.user_path(user.id)
  end
end

class UsersController < ApplicationController
  use_handler do
    UsersHandler.new
  end
end
