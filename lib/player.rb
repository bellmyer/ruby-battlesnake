require 'battlesnake'

# TODO: flood fill
# TODO: prefer your own tail if it's adjacent to head

class Player
  attr_reader :data, :board, :player, :logger

  MAX_PATH_DISTANCE = 6

  def initialize(data, logger)
    @data = data
    @board = Battlesnake::Board.new(data['board'])
    @player = Battlesnake::Snake.new(data['you'])

    @logger = logger
  end

  def move
    adjacent_tail(player) || nearby_food || find_empty
  end

  private

  def available_directions
    return @available_directions if defined?(@available_directions)
    @available_directions = board.available_directions(player.head)
  end

  def random_directions
    available_directions.shuffle
  end

  def adjacent_tail(snake)
    tail = snake.body.last

    directions_to_locations(player.head, Battlesnake::Location::DIRECTIONS).detect do |location|
      location == tail
    end
  end

  def nearby_food
    direction_to(nearest_path_to(board.food))
  end

  def nearest_path_to(locations)
    Array(locations).map do |location|
      board.find_path(player.head, location, max_distance: MAX_PATH_DISTANCE)
    end.compact.min_by(&:size)
  end

  def direction_to(path)
    return nil if path.nil?
    path[0].direction(path[1])
  end

  def direction_to_location(location, direction)
    location.move(direction)
  end

  def directions_to_locations(location, directions)
    directions.map{ |d| direction_to_location(location, d) }
  end

  def find_empty
    random_directions.first
  end

  # def find_most_empty
  #   locations = available_directions
  #   available_directions.max_by do |direction|
  #
  #   end
  # end

  # def nearest_available_wall
  #   DIRECTIONS.select{ |d| available?(send(d)) }.min_by do |d|
  #     distance_to_wall(d)
  #   end
  # end
end