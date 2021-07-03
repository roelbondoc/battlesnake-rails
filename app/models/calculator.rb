class Calculator
  attr_reader :game_id, :turn

  def initialize(game_id, turn)
    @game_id = game_id
    @turn = turn
  end

  def move
    valid_moves.sample || %w(up down left right).sample
  end

  def valid_moves
    [].tap do |moves|
      moves << 'up' if can_move_up?
      moves << 'down' if can_move_down?
      moves << 'left' if can_move_left?
      moves << 'right' if can_move_right?
    end
  end

  def can_move_up?
    y < max_y-1 && empty?(x, y+1)
  end

  def can_move_down?
    y > 0 && empty?(x, y-1)
  end

  def can_move_left?
    x > 0 && empty?(x-1, y)
  end

  def can_move_right?
    x < max_x-1 && empty?(x+1, y)
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

  def x
    head.x
  end

  def y
    head.y
  end

  def head
    @head ||= coordinates.me.head.first
  end

  def coordinates
    Coordinate.where(game_id: game_id, turn: turn)
  end
end
