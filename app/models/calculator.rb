class Calculator
  attr_reader :game_id, :turn

  def initialize(game_id, turn)
    @game_id = game_id
    @turn = turn
  end

  def move
    ((prioritized_moves & valid_moves) - possible_hazard_moves).first ||
      (prioritized_moves & valid_moves).first ||
      (valid_moves - possible_hazard_moves).sample ||
      valid_moves.sample ||
      %w(up down left right).sample
  end

  def prioritized_moves
    @prioritized_moves ||= [].tap do |moves|
      direction = health_in_danger? ? :asc : :desc
      coordinates.food.order(distance: direction).map do |food|
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
    end.uniq
  end

  def valid_moves
    @valid_moves ||= [].tap do |moves|
      moves << 'up' if can_move_up?
      moves << 'down' if can_move_down?
      moves << 'left' if can_move_left?
      moves << 'right' if can_move_right?
    end
  end

  def possible_hazard_moves
    @possible_hazard_moves ||= [].tap do |moves|
      moves << 'up' if possible_stonger_head?(head_x, head_y+1)
      moves << 'down' if possible_stonger_head?(head_x, head_y-1)
      moves << 'left' if possible_stonger_head?(head_x+1, head_y)
      moves << 'right' if possible_stonger_head?(head_x-1, head_y)
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

  def health_in_danger?
    head_health <= 50
  end

  def empty?(x, y)
    dont_avoid = if head_in_hazard? || !health_in_danger?
                   %i[food hazard]
                 else
                   :food
                 end
    coordinates.where.not(content_type: dont_avoid).where(x: x, y: y).blank?
  end

  def possible_stonger_head?(x, y)
    coordinates.not_me.head.where('length >= ?', head_length).any? do |other_head|
      (x == other_head.x && y == other_head.y + 1) ||
        (x == other_head.x && y == other_head.y - 1) ||
      (x == other_head.x + 1 && y == other_head.y) ||
        (x == other_head.x - 1 && y == other_head.y)
    end
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

  def head_health
    head.health
  end

  def head_length
    head.length
  end

  def head_in_hazard?
    coordinates.hazard.where(x: head_x, y: head_y).exists?
  end

  def head
    @head ||= coordinates.me.head.first
  end

  def coordinates
    Coordinate.where(game_id: game_id, turn: turn)
  end
end
