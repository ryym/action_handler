class MypageController < ApplicationController
  use_handler { MypageHandler.new }
end

class MypageHandler
  include ActionHandler::Proto::Support

  as_controller do
    before_action do
      @user = User.find_by(id: session[:user_id])
      redirect_to login_path if @user.nil?
    end
  end

  action_args do |_, ctrl|
    user = ctrl.instance_variable_get(:@user)
    [user]
  end

  def initialize(greeter: MypageService.new)
    @greeter = greeter
  end

  def index(user)
    render locals: {
      user: user,
      welcome: @greeter.welcome(user),
    }
  end
end
