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
    starting_pos = get_starting_pos
    ending_pos = get_ending_pos
    move_piece(starting_pos, ending_pos)
  end

  def get_starting_pos
    starting_pos = nil

    until valid_starting_pos?(starting_pos)
      puts "It's #{@current_player.name}'s turn! (#{@current_player.color})"
      starting_pos = @current_player.get_move(@display)
      @display.render
    end

    puts "you have selected the #{@board[starting_pos].color} #{@board[starting_pos].type}!"
    @board.starting_pos = starting_pos
  end

  def valid_starting_pos?(pos)
    # pos may be nil because of cursorable.rb:47, moving will return nil
    return false if pos.nil?
    piece = @board[pos]
    piece.color == @current_player.color
    # && @board.has_available_moves(piece)
  end

  def get_ending_pos

  end

  def move_piece(starting_pos, ending_pos)
    @board.move_piece(starting_pos, ending_pos)
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
