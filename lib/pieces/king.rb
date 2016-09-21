require_relative 'stepable'
require_relative 'piece'

class King < Piece
  include Stepable
end
