class PingsHandler
  include ActionHandler::Equip

  def index
    { locals: { pong: :pong_from_handler } }
  end

  def show(params, format)
    if format == :json
      render json: {
        id: params[:id],
        pong: "pong by #{params[:id]}",
      }
    else
      render plain: 'Pong!'
    end
  end
end

class PingsController < ApplicationController
  use_handler { PingsHandler.new }
end
