require './board'
require './display'

class Game
  def initialize
    @board = Board.new
    @display = Display.new(@board)
  end

  def play
    # until game_won
      @display.render
    # end
  end

  def game_won

  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
