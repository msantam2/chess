require './board'
require './display'
require './human_player'
require './computer_player'
require 'byebug'

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
      play_turn
      switch_players
    end

    declare_winner
  end

  def play_turn
    start_pos = get_start_pos
    end_pos = get_end_pos
    move_piece(start_pos, end_pos)
  end

  def get_start_pos
    start_pos = nil

    until valid_start_pos?(start_pos)
      puts "It's #{@current_player.name}'s turn! (#{@current_player.color})"
      start_pos = @current_player.get_move(@display)
      # board instance variable start_pos for display to render green
      @board.start_pos = start_pos
      @display.render
    end

    puts "you have selected the #{@board[start_pos].type}!"
    start_pos
  end

  def valid_start_pos?(pos)
    @board.valid_start_pos?(pos, @current_player.color)
  end

  def get_end_pos
    end_pos = nil

    until valid_end_pos?(end_pos)
      puts "choose where you would like to move your #{@board[@board.start_pos].type}, #{@current_player.name}."
      end_pos = @current_player.get_move(@display)
      @display.render
    end

    end_pos
  end

  def valid_end_pos?(pos)
    @board.valid_end_pos?(pos)
  end

  def move_piece(start_pos, end_pos)
    @board.move_piece(start_pos, end_pos)
  end

  def choose_players
    puts "Welcome to Chess! Type '1' for a human vs. human game, '2' for human vs. computer, or '3' to watch 2 computers duke it out! Then hit enter:"

    player_choice = gets.chomp.to_i
    case player_choice
      when 1
        print 'type a name for player1:   '
        player1_name = gets.chomp
        print 'type a name for player2:   '
        player2_name = gets.chomp
        @player1 = HumanPlayer.new(player1_name, :black)
        @player2 = HumanPlayer.new(player2_name, :white)
        puts "#{player1_name} will be facing #{player2_name}! Let's go!"
      when 2
        print 'type your name:   '
        player_name = gets.chomp
        @player1 = HumanPlayer.new(player_name, :black)
        @player2 = ComputerPlayer.new('Cathy the Computer', :white)
        puts 'you will be facing Cathy the Computer!'
      when 3
        @player1 = ComputerPlayer.new('MacBook Miller', :black)
        @player2 = ComputerPlayer.new('PC Jones', :white)
        puts 'you will watch MacBook Miller duke it out with PC Jones!'
    end
  end

  def switch_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def game_won
    @board.flatten.none? do |piece|
      piece.type == :king && piece.color == @current_player.color
    end
  end

  def declare_winner
    puts "#{switch_players}.name has won the game! Would you like to play again? (y or n)"
    answer = gets.chomp
    answer == 'y' ? self.play : nil
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
