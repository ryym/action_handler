class PingsHandler
  include ActionHandler::Equip

  def index
    { locals: { pong: :pong_from_handler } }
  end

  def show(params)
    render json: {
      id: params[:id],
      pong: "pong by #{params[:id]}",
    }
  end
end

class PingsController < ApplicationController
  use_handler { PingsHandler.new }
end
