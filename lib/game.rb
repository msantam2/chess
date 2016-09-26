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
    @first_move = true
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
    if @first_move
      declare_first_player
      @first_move = false
    end

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

  def declare_first_player
    puts "#{@player1.name} will be facing #{@player2.name}! Let's go!"
    puts "#{@current_player.name} will be going first! Godspeed."
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

    @board.start_pos = nil
    end_pos
  end

  def valid_end_pos?(pos)
    @board.valid_end_pos?(pos)
  end

  def move_piece(start_pos, end_pos)
    @board.move_piece(start_pos, end_pos)
  end

  def give_greeting
    puts "Welcome to Chess!"
    puts "Type '1' for a human vs. human game, '2' for human vs. computer, or '3' to watch 2 computers duke it out! Then hit enter:"
  end

  def choose_players
    give_greeting

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
    @board.flatten.none? do |piece|
      piece.type == :king && piece.color == @current_player.color
    end
  end

  def declare_winner
    @display.render
    puts "#{switch_players.name} has won the game! Would you like to play again? (y or n)"
    answer = gets.chomp
    answer == 'y' ? Game.new.play : nil
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
