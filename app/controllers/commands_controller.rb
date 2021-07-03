class CommandsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def battlesnake
    render json: {
      apiversion: '1',
      author: 'godspeed'
    }
  end

  def start
    render json: {}
  end

  def move
    render json: {
      move: %w(up down left right).sample
    }
  end

  def finished
    render json: {}
  end
end
