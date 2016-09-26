require_relative 'slideable'
require_relative 'piece'

class Bishop < Piece
  include Slideable

  def move_directions
    [:left_up, :right_up, :left_down, :right_down]
  end
end
