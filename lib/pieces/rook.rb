require_relative 'slideable'
require_relative 'piece'

class Rook < Piece
  include Slideable

  def move_directions
    [:up, :down, :left, :right]
  end
end
