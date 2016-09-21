require 'colorize'

class Display
  PIECE_UNICODES = {
    king: " \u265A ",
    queen: " \u265B ",
    bishop: " \u265C ",
    knight: " \u265D ",
    rook: " \u265E ",
    pawn: " \u265F ",
    nullpiece: '   '
  }


  def initialize(board)
    @board = board
  end

  def render
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
      background = switch ? :magenta : :cyan
      piece_str = piece.is_a?(NullPiece) ? PIECE_UNICODES[:nullpiece] : PIECE_UNICODES[piece.type]
      color = piece.is_a?(NullPiece) ? background : piece.color

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
