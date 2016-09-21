require_relative 'stepable'
require_relative 'piece'

class Pawn < Piece
  include Stepable
end
