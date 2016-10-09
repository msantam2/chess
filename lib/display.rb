require 'colorize'
require_relative 'cursorable'

class Display
  include Cursorable

  PIECE_UNICODES = {
    king: " \u265A ",
    queen: " \u265B ",
    rook: " \u265C ",
    bishop: " \u265D ",
    knight: " \u265E ",
    pawn: " \u265F ",
    nullpiece: '   '
  }

  attr_reader :board
  attr_accessor :cursor_pos

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def switch_players
    @current_player = @current_player.color == :white ? :black : :white
  end

  def render(current_player)
    system('clear')
    render_letters_row

    board.grid.each_with_index do |row, row_idx|
      render_row(current_player, row, row_idx)
      puts
    end

    render_letters_row
  end

  def render_row(current_player, row, row_idx)
    print "#{8 - row_idx} "

    switch = row_idx.even? ? true : false
    row.each_with_index do |piece, piece_idx|
      background = :green if @board.start_pos == [row_idx, piece_idx]
      if @board[@cursor_pos].moves(@board, @cursor_pos).include?([row_idx, piece_idx]) && !@board.start_pos && board[@cursor_pos].color == current_player.color
        background = :yellow
      end
      if @board.start_pos && @board[@board.start_pos].color == current_player.color
        if @board[@board.start_pos].moves(@board, @board.start_pos).include?([row_idx, piece_idx])
          background = :yellow
        end
      end
      background = :blue if @cursor_pos == [row_idx, piece_idx]
      background ||= switch ? :magenta : :cyan

      piece_str, color = [PIECE_UNICODES[piece.type], piece.color || background]

      print piece_str.colorize(color: color, background: background)

      switch = !switch
    end



    print " #{8 - row_idx}"
  end

  def render_letters_row
    print '  '
    ('a'..'h').each do |letter|
      print " #{letter} "
    end
    print '  '
    puts
  end
end
