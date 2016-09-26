require 'colorize'
require_relative './cursorable'
require 'byebug'

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

  attr_reader :board, :cursor_pos, :selected
  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    @selected = false
  end

  def render
    system('clear')
    render_letters_row

    board.each_with_index do |row, row_idx|
      render_row(row, row_idx)
      puts
    end

    render_letters_row
  end

  def render_row(row, row_idx)
    print "#{8 - row_idx} "

    switch = row_idx.even? ? true : false
    row.each_with_index do |piece, piece_idx|
      background = :green if @board.start_pos == [row_idx, piece_idx]
      background = :light_blue if @cursor_pos == [row_idx, piece_idx]
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

  private

  def board
    @board.grid
  end
end
