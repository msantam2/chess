require_relative 'player'
require 'deep_clone'
require 'require_all'
require_all 'pieces'

class ComputerPlayer < Player
  # most common assignment of point values in modern day chess
  # (excluding :nullpiece). The King is assigned a very large arbitrary value - clearly the most valuable!
  PIECE_VALUES = {
    nullpiece: 0,
    pawn: 1,
    knight: 3,
    bishop: 3,
    rook: 5,
    queen: 9,
    king: 1000
  }

  def initialize(name, color)
    super(name, color)
    @end_pos = nil
  end

  def get_move(display)
    if display.board.start_pos.nil?
      # creates entire move (start position and end position).
      # returns start position to the Game now
      # and caches end position as @end_pos
      # until the game asks for it. @end_pos is returned
      # via the 'else' statement below.
      select_move(display.board)
    else # getting end_pos and resetting it.
      sleep(1.5)
      current_end_pos = @end_pos
      @end_pos = nil
      current_end_pos
    end
  end

  def select_move(board)
    sleep(1.5)
    # explanation of the following structure: the computer cannot be in
    # checkmate without already being in check. Since #in_check? is
    # a much less expensive operation and a player being in check is not
    # incredibly common, we first evaluate if the player is in check.
    # if not, no reason to run #in_checkmate?. the second 'else'
    # indicates the computer is neither in check nor checkmate. still,
    # though, any move it makes should avoid check, which is why
    # #avoid_check_start_pos is called.
    if board.in_check?(self.color)
      if board.in_checkmate?(self.color)
        random_move(all_start_positions(board))
      else
        avoid_check_move(board)
      end
    else
      avoid_check_move(board)
    end
  end

  def all_start_positions(board)
    all_start_positions = []

    board.grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        current_pos = [row_idx, col_idx]
        if board.valid_start_pos?(current_pos, self.color)
          all_start_positions << current_pos
        end
      end
    end

    all_start_positions
  end

  def avoid_check_move(board)
    moves = Hash.new { |hash, key| hash[key] = [] }

    all_start_positions(board).each do |start_pos|
      piece = board[start_pos]
      possible_end_positions = piece.moves(board, start_pos)
      possible_end_positions.each do |end_pos|
        new_board = DeepClone.clone(board)
        new_board.move_piece(start_pos, end_pos)
        if !new_board.in_check?(self.color)
          moves[start_pos] << end_pos
        end
      end
    end

    force_check_filter(board, moves)
  end

  # this method accepts moves and if any of the moves can
  # force the computer's opponent into checkmate, this move will be
  # immediately chosen. if any moves can force the computer's opponent
  # into check, it will be included as one of the moves that must
  # eventually be chosen in #highest_value_capture_filter.
  def force_check_filter(board, moves)
    force_check_moves = Hash.new { |hash, key| hash[key] = [] }

    moves.each do |start_pos, end_positions|
      end_positions.each do |end_pos|
        new_board = DeepClone.clone(board)
        new_board.move_piece(start_pos, end_pos)
        if new_board.in_checkmate?(opponent_color)
          @end_pos = end_pos
          return start_pos
        elsif new_board.in_check?(opponent_color)
          force_check_moves[start_pos] << end_pos
        end
      end
    end

    new_moves = force_check_moves.empty? ? moves : force_check_moves
    highest_value_capture_filter(board, new_moves)
  end

  # this method will evaluate if the computer has more than one capture
  # opportunity available. If so, it will capture the piece with the
  # 'highest value', i.e. computer will take a Queen over a Pawn.
  def highest_value_capture_filter(board, moves)
    capture_data = Hash.new { |hash, key| hash[key] = {} }

    moves.each do |start_pos, end_positions|
      end_positions.each do |end_pos|
        piece = board[end_pos]
        capture_data[start_pos][end_pos] = piece.type
      end
    end

    highest_value_capture = 0
    start_position = nil
    end_position = nil
    capture_data.each do |start_pos, end_pos_data|
      end_pos_data.each do |end_pos, piece_type|
        if PIECE_VALUES[piece_type] > highest_value_capture
          highest_value_capture = PIECE_VALUES[piece_type]
          start_position = start_pos
          end_position = end_pos
        end
      end
    end

    start_position ||= random_start_pos(moves.keys)
    end_position ||= random_end_pos(moves[start_position])
    @end_pos = end_position
    start_position
  end

  def random_start_pos(start_positions)
    start_positions.sample
  end

  def random_end_pos(end_positions)
    end_positions.sample
  end

  def opponent_color
    self.color == :black ? :white : :black
  end
end
