require_relative 'stepable'
require_relative 'piece'

class King < Piece
  include Stepable

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
