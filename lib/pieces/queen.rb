require_relative 'slideable'
require_relative 'stepable'
require_relative 'piece'

class Queen < Piece
  include Slideable

  def move_directions
    [
      :up,
      :down,
      :left,
      :right,
      :left_up,
      :right_up,
      :left_down,
      :right_down
    ]
  end
end
