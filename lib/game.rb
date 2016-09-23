require './board'
require './display'
require './human_player'
require './computer_player'

class Game
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    choose_players
    @current_player = [@player1, @player2].sample
  end

  def play
    until game_won
      @display.render
      puts "It's #{@current_player.name}'s turn!"
      @current_player.get_move(@display)
    end
  end

  def choose_players
    puts "Welcome to Chess! Type '1' for a human vs. human game, '2' for human vs. computer, or '3' to watch 2 computers duke it out!"

    player_choice = gets.chomp.to_i
    case player_choice
      when 1
        print 'type a name for player1:   '
        player1_name = gets.chomp
        print 'type a name for player2:   '
        player2_name = gets.chomp
        @player1 = HumanPlayer.new(player1_name, :black)
        @player2 = HumanPlayer.new(player2_name, :white)
      when 2
        print 'type your name:   '
        player_name = gets.chomp
        @player1 = HumanPlayer.new(player_name, :black)
        @player2 = ComputerPlayer.new('Cathy the Computer', :white)
      when 3
        @player1 = ComputerPlayer.new('MacBook Miller', :black)
        @player2 = ComputerPlayer.new('PC Jones', :white)
    end
  end

  def switch_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def game_won
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
