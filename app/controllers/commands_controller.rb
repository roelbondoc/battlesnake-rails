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
    Parser.new(params).parse
    calculator = Calculator.new(
      params.dig(:game, :id),
      params.dig(:turn),
      params.dig(:you, :id)
    )

    render json: {
      move: calculator.move
    }
  end

  def finished
    render json: {}
  end
end
