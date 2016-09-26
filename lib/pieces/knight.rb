require_relative 'stepable'
require_relative 'piece'

class Knight < Piece
  include Stepable

  def move_directions
    [
      [:up, :up, :left],
      [:up, :up, :right],
      [:up, :right, :right],
      [:down, :right, :right],
      [:down, :down, :right],
      [:down, :down, :left],
      [:down, :left, :left],
      [:up, :left, :left]
    ]
  end
end
