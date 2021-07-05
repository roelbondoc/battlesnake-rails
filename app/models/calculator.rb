class Calculator
  attr_reader :game_id, :turn

  def initialize(game_id, turn)
    @game_id = game_id
    @turn = turn
  end

  def move
    ((prioritized_moves & valid_moves) - (possible_hazard_moves + too_crowded_moves(1))).first ||
    ((prioritized_moves & valid_moves) - (possible_hazard_moves + too_crowded_moves(2))).first ||
    ((prioritized_moves & valid_moves) - too_crowded_moves).first ||
    ((prioritized_moves & valid_moves) - possible_hazard_moves).first ||
      (prioritized_moves & valid_moves).first ||
      (valid_moves - possible_hazard_moves).sample ||
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
    end.uniq
  end

  def valid_moves
    @valid_moves ||= [].tap do |moves|
      moves << 'up' if can_move_up?(head_x, head_y)
      moves << 'down' if can_move_down?(head_x, head_y)
      moves << 'left' if can_move_left?(head_x, head_y)
      moves << 'right' if can_move_right?(head_x, head_y)
    end
  end

  def number_of_valid_moves(x, y)
    count = 0
    count = count + 1 if can_move_up?(x, y)
    count = count + 1 if can_move_down?(x, y)
    count = count + 1 if can_move_left?(x, y)
    count = count + 1 if can_move_right?(x, y)
    count
  end

  def next_moves_number_of_moves
    @next_moves_number_of_moves ||= [].tap do |moves|
      moves << ['up', number_of_valid_moves(head_x, head_y+1)] if valid_moves.include?('up')
      moves << ['down', number_of_valid_moves(head_x, head_y-1)] if valid_moves.include?('down')
      moves << ['left', number_of_valid_moves(head_x-1, head_y)] if valid_moves.include?('left')
      moves << ['right', number_of_valid_moves(head_x+1, head_y)] if valid_moves.include?('right')
    end
  end

  def too_crowded_moves(moves_to_filter_out)
    next_moves_number_of_moves.map do |dir, number_of_moves|
      dir if number_of_moves < moves_to_filter_out
    end.compact
  end

  def possible_hazard_moves
    @possible_hazard_moves ||= [].tap do |moves|
      moves << 'up' if possible_stonger_head?(head_x, head_y+1)
      moves << 'down' if possible_stonger_head?(head_x, head_y-1)
      moves << 'left' if possible_stonger_head?(head_x-1, head_y)
      moves << 'right' if possible_stonger_head?(head_x+1, head_y)
    end
  end

  def can_move_up?(x, y)
    y < max_y-1 && empty?(x, y+1)
  end

  def can_move_down?(x, y)
    y > 0 && empty?(x, y-1)
  end

  def can_move_left?(x, y)
    x > 0 && empty?(x-1, y)
  end

  def can_move_right?(x, y)
    x < max_x-1 && empty?(x+1, y)
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
