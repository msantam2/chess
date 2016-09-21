require_relative 'slideable'
require_relative 'stepable'
require_relative 'piece'

class Queen < Piece
  include Slideable
  include Stepable

end
