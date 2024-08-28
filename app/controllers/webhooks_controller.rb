require 'pry'
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def voice
    game = Game.find_by(channel_id: params[:conversation_uuid])
    response = game.interface.process_input(game, params)
    render json: response, status: :ok
  end

  def sms
    game = Game.where(channel_id: params[:from]).last

    game.interface.process_input(game, params)
    head :ok
  end

  def status
    head :ok
  end
end