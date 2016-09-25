require 'singleton'

class NullPiece
  include Singleton

  attr_reader :type, :color

  def initialize
    @type = :nullpiece
    @color = nil
  end
end
