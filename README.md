# Chess

Enjoy a fun and elegant way to play chess directly from the comfort of your own terminal! Play your friend, play the computer, or just sit back, relax and watch two computers battle it out!

<img src="https://github.com/msantam2/chess/blob/master/images/chess_gameplay.gif" width="555" height="520" />

__________

### Run this Code

Play Chess in 3 simple steps! (You will need to have Ruby installed on your computer):

1. Run ```git clone https://github.com/msantam2/chess.git``` from the CLI.

2. Navigate to your Chess directory and run ```bundle install``` for a beautiful looking board as well as keyboard I/O. ```cd lib/``` to enter into the ```lib/``` directory.

3. Run ```ruby game.rb``` and you're off! Zoom in on the terminal for clearer and better gameplay! (```cmd-shift-+```).

__________

### Playing the Game

- (After running ```ruby game.rb```) Follow the prompts to select your choice of gameplay.

- For all human players (robots excluded!) simply use the arrows on your keyboard to navigate the board. Once you are hovering over the piece you would like to move, press ```Enter```. Next, navigate to the space you would like to move to and press ```Enter```. If no valid moves exist for a certain piece, it cannot be selected. Be careful, once a piece is selected it cannot be de-selected!

- The cursor is represented by a yellow background when navigating, and a selected piece with a green background.

- To quit a game, press ```ctrl-C```.

__________

# Technologies

Chess is built with pure Ruby code, exhibiting the principles of clean Object-Oriented Design. Each file contains only one class, implementing class inheritance where appropriate to ensure DRY code. The ```colorize``` gem is used to render a beautiful chess board, along with the ```io/console``` gem in ```cursorable.rb``` to read standard input (```STDIN```).

## Implemention Details

### Modules

```Slideable``` and ```Stepable``` modules are mixed-in to each piece class to provide it with a ```moves``` method, according to its specific move behavior and whether it is fundamentally a stepping piece or a sliding piece.

This structure allows each piece class to have a simple ```move_directions``` method that specifies the directions it can move:

```rb
class Rook < Piece
  include Slideable

  def move_directions
    [:up, :down, :left, :right]
  end
end
```
Instances of Rook can slide in any non-diagonal direction.

```rb
class Knight < Piece
  include Stepable

  def move_directions
    [
      [:up, :up, :left],
      [:up, :up, :right],
      [:up, :right, :right],
      [:down, :right, :right],
      [:down, :down, :right],
      [:down, :down, :left],
      [:down, :left, :left],
      [:up, :left, :left]
    ]
  end
end
```
Instances of Knight can step in any direction with a combination of 3 successive steps.

### Null Object Pattern

For empty spaces, a Null Object pattern is used to keep code DRY and easy-to-understand. The NullPiece is instantiated (only once in memory) with the following instance variables in order to integrate smoothly into the game logic (i.e. the ```game``` does not care what piece it is dealing with, only that is can always call ```.type``` and ```.color``` on each piece):

```rb
def initialize
  @type = :nullpiece
  @color = nil
end
```

When a piece is successfully captured, the NullPiece is set in its place:

```rb
def move_piece(start_pos, end_pos)
  piece = self[start_pos]
  self[start_pos] = NullPiece.instance
  self[end_pos] = piece
end
```

### Winning Condition

A simple check is done after each player's turn to assess whether or not the game has been won:

```rb
def game_won
  @board.flatten.none? do |piece|
    piece.type == :king && piece.color == @current_player.color
  end
end
```
The ```game``` checks its ```@board``` immediately after the game has switched players to see if the current player's king remains (if it does not, it has been captured by the previous player and the game is over)

### AI (Deep Dup)
