# frozen_string_literal: true

class MypageHandler
  include ActionHandler::Equip

  args SessionArgs.instance

  arg(:theme) do |ctrl|
    ctrl.params[:theme]
  end

  def initialize(greeter: MypageService.new)
    @greeter = greeter
  end

  def index(current_user, theme)
    render locals: {
      user: current_user,
      welcome: @greeter.welcome(current_user, theme),
    }
  end
end

class MypageController < ApplicationController
  use_handler { MypageHandler.new }

  before_action do
    redirect_to login_path if current_user.nil?
  end
end
