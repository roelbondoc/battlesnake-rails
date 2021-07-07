class Parser
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def parse
    parse_food
    parse_hazards
    parse_snakes
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
        distance: distance(food[:x], food[:y]),
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
        distance: distance(hazard[:x], hazard[:y]),
        content_type: :hazard
      )
    end
  end

  def parse_snakes
    params.dig(:board, :snakes)&.each do |snake|
      Coordinate.create(
        turn: turn,
        snake_id: snake[:id],
        max_x: max_x,
        max_y: max_y,
        game_id: game_id,
        x: snake.dig(:head, :x),
        y: snake.dig(:head, :y),
        distance: distance(snake.dig(:head, :x), snake.dig(:head, :y)),
        is_me: false,
        health: snake[:health],
        length: snake[:length],
        content_type: :head
      )

      snake[:body]&.each_with_index do |body, index|
        Coordinate.create(
          turn: turn,
          snake_id: snake[:id],
          max_x: max_x,
          max_y: max_y,
          game_id: game_id,
          x: body[:x],
          y: body[:y],
          distance: distance(body[:x], body[:y]),
          is_me: false,
          health: snake[:health],
          length: snake[:length],
          content_type: index+1 == snake[:length] ? :tail : :body
        )
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

  def distance(x2, y2)
    x1 = params.dig(:you, :head)[:x]
    y1 = params.dig(:you, :head)[:y]

    Integer.sqrt((x2 - x1)**2 + (y2 - y1)**2)
  end
end
