require_relative 'stepable'
require_relative 'piece'

class Pawn < Piece
  include Stepable

  def move_directions
    self.color == :black ? [:down, :left_down, :right_down] : [:up, :left_up, :right_up]
  end
end
