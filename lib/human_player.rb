require './player'

class HumanPlayer < Player
  def get_move(display)
    display.get_input
  end

  def moves

  end
end
