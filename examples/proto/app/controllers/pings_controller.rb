# frozen_string_literal: true

class PingsHandler
  include ActionHandler::Proto::Support

  as_controller do
    before_action do
      Rails.logger.debug 'logging...........'
    end
  end

  action_args do |action, ctrl|
    case action
    when :show
      [ctrl.params[:id]]
    else
      [ctrl.params]
    end
  end

  def index
    render plain: 'hello from handler'
  end

  def show(id)
    render plain: "ping: #{id}, included: #{@included}"
  end

  def show_params(params)
    render json: params.permit(:a, :b, :c).to_h
  end
end

class PingsController < ApplicationController
  use_handler do
    PingsHandler.new
  end
end
