# frozen_string_literal: true

class UsersHandler
  include ActionHandler::Equip

  args_params user: %i[name]

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

  def create(user)
    user = User.create!(user)
    redirect_to urls.user_path(user.id)
  end
end

class UsersController < ApplicationController
  use_handler { UsersHandler.new }
end
