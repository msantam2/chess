require 'singleton'

class NullPiece
  include Singleton

  attr_reader :type, :color

  def initialize
    @type = :nullpiece
    @color = nil
  end

  def moves(board, start_pos)
    []
  end
end
