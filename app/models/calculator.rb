class Calculator
  attr_reader :game_id, :turn

  def initialize(game_id, turn)
    @game_id = game_id
    @turn = turn
  end

  def move
    (prioritized_moves & valid_moves).first ||
      valid_moves.sample ||
      %w(up down left right).sample
  end

  def prioritized_moves
    @prioritized_moves ||= [].tap do |moves|
      coordinates.food.order(distance: :asc).map do |food|
        if head_x < food.x
          moves << 'right'
        elsif head_x > food.x
          moves << 'left'
        end

        if head_y < food.y
          moves << 'up'
        elsif head_y > food.y
          moves << 'down'
        end
      end
    end
  end

  def valid_moves
    @valid_moves ||= [].tap do |moves|
      moves << 'up' if can_move_up?
      moves << 'down' if can_move_down?
      moves << 'left' if can_move_left?
      moves << 'right' if can_move_right?
    end
  end

  def can_move_up?
    head_y < max_y-1 && empty?(head_x, head_y+1)
  end

  def can_move_down?
    head_y > 0 && empty?(head_x, head_y-1)
  end

  def can_move_left?
    head_x > 0 && empty?(head_x-1, head_y)
  end

  def can_move_right?
    head_x < max_x-1 && empty?(head_x+1, head_y)
  end

  def empty?(x, y)
    coordinates.where.not(content_type: :food).where(x: x, y: y).blank?
  end

  def max_y
    head.max_y
  end

  def max_x
    head.max_x
  end

  def head_x
    head.x
  end

  def head_y
    head.y
  end

  def head
    @head ||= coordinates.me.head.first
  end

  def coordinates
    Coordinate.where(game_id: game_id, turn: turn)
  end
end
