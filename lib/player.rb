class Player
  attr_reader :data, :board, :player, :occupieds

  DIRECTIONS = ['up', 'down', 'left', 'right']

  def initialize(data)
    @data = data
    @board = data['board']
    @player = data['you']

    @occupieds = @board['snakes'].map{|s| s['body']}.flatten
  end

  def move
    find_empty


  end

  private

  def find_empty
    random if direction.nil? || occupied?(send(direction))

    send(direction)
  end

  def random
    DIRECTIONS.shuffle.detect{|d| !occupied?(send(d)) }
    'down'
  end

  def direction
    return @direction if defined?(@direction)
    return @direction = nil unless neck

    @direction = if neck == left
      'right'
    elsif neck == right
      'left'
    elsif neck == down
      'up'
    elsif neck == up
      'down'
    else
      raise "no valid direction!!!"
    end
  end

  def left
    head.merge('x' => head['x'] - 1)
  end

  def right
    head.merge('x' => head['x'] + 1)
  end

  def up
    head.merge('y' => head['y'] + 1)
  end

  def down
    head.merge('y' => head['y'] - 1)
  end

  def occupied?(coords)
    occupieds.include?(coords)
  end

  def head
    return @head if defined?(@head)
    @head = player['body'].first
  end

  def neck
    return @neck if defined?(@neck)
    @neck = player['body'][1]
  end
end