# frozen_string_literal: true

# WARNING: This is just a sample of action handler.
class SessionsHandler
  include ActionHandler::Equip

  args SessionArgs.instance

  def index(current_user)
    redirect_to urls.mypage_path if current_user
  end

  def login(params, session, reset_session)
    user = User.find_by(name: params[:name])
    if user.nil?
      return redirect_to urls.login_path, alert: "#{params[:name]} does not exist"
    end

    reset_session.call
    session[:user_id] = user.id
    redirect_to urls.mypage_path
  end

  def logout(session)
    session.delete(:user_id)
    redirect_to urls.login_path
  end
end

class SessionsController < ApplicationController
  use_handler { SessionsHandler.new }
end
