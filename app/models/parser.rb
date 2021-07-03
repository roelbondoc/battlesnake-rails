class Parser
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def parse
    parse_food
    parse_hazards
    parse_my_snake
    parse_other_snakes
  end

  def parse_food
    params.dig(:board, :food)&.each do |food|
      Coordinate.create(
        turn: turn,
        max_x: max_x,
        max_y: max_y,
        game_id: game_id,
        x: food[:x],
        y: food[:y],
        content_type: :food
      )
    end
  end

  def parse_hazards
    params.dig(:board, :hazards)&.each do |hazard|
      Coordinate.create(
        turn: turn,
        max_x: max_x,
        max_y: max_y,
        game_id: game_id,
        x: hazard[:x],
        y: hazard[:y],
        content_type: :hazard
      )
    end
  end

  def parse_my_snake
    Coordinate.create(
      turn: turn,
      snake_id: params.dig(:you, :id),
      max_x: max_x,
      max_y: max_y,
      game_id: game_id,
      x: params.dig(:you, :head)[:x],
      y: params.dig(:you, :head)[:y],
      is_me: true,
      content_type: :head
    )

    params.dig(:you, :body)&.each do |body|
      Coordinate.create(
        turn: turn,
        snake_id: params.dig(:you, :id),
        max_x: max_x,
        max_y: max_y,
        game_id: game_id,
        x: body[:x],
        y: body[:y],
        is_me: true,
        content_type: :body
      )
    end
  end

  def parse_other_snakes
    params.dig(:board, :snakes)&.each do |snake|
      if snake[:id] != params.dig(:you, :id)
        Coordinate.create(
          turn: turn,
          snake_id: snake[:id],
          max_x: max_x,
          max_y: max_y,
          game_id: game_id,
          x: snake[:head][:x],
          y: snake[:head][:y],
          is_me: false,
          content_type: :head
        )

        snake[:body]&.each do |body|
          Coordinate.create(
            turn: turn,
            snake_id: snake[:id],
            max_x: max_x,
            max_y: max_y,
            game_id: game_id,
            x: body[:x],
            y: body[:y],
            is_me: false,
            content_type: :body
          )
        end
      end
    end
  end

  def max_x
    params.dig(:board, :width)
  end

  def max_y
    params.dig(:board, :height)
  end

  def game_id
    params.dig(:game, :id)
  end

  def turn
    params.dig(:turn)
  end
end
