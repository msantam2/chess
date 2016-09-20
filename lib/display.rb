require 'colorize'

class Display
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
    print "#{8 - row_idx}"

    switch = row_idx.even? ? true : false
    row.each_with_index do |tile, tile_idx|
      switch ? (print tile.colorize(background: :magenta)) : (print tile.colorize(background: :cyan))

      switch = !switch
    end

    print "#{8 - row_idx}"
  end

  def render_letters_row
    print ' '
    ('a'..'h').each do |letter|
      print letter
    end
    print ' '
    puts
  end

  private

  def board
    @board.grid
  end
end
