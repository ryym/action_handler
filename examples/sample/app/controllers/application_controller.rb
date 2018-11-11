# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionHandler::Controller

  helper_method :current_user

  def current_user
    unless @current_user_set
      user_id = session[:user_id]
      @current_user = User.find_by(id: user_id) if user_id
      @current_user_set = true
    end
    @current_user
  end
end
