# frozen_string_literal: true

# WARNING: This is just a sample of action handler.
class SessionsHandler
  include ActionHandler::Proto::Support

  action_args do |action, ctrl|
    case action
    when :login
      [ctrl.params, ctrl.session, ctrl.method(:reset_session)]
    when :logout
      [ctrl.session]
    end
  end

  def index; end

  # reset_session も引数でもらうのはさすがにイマイチ。
  def login(params, session, reset_session)
    user = User.find_by!(name: params[:name])
    reset_session.call
    session[:user_id] = user.id
    redirect_to url_helpers.mypage_path
  end

  def logout(session)
    session.delete(:user_id)
    redirect_to url_helpers.login_path
  end
end

class SessionsController < ApplicationController
  use_handler do
    # XXX: ここはコントローラのインスタンスじゃないから、reset_session とか
    # インスタンスのものは見れない...!
    SessionsHandler.new
  end
end
