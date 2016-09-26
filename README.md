# Chess

Enjoy a fun and elegant game of chess directly from the comfort of your own terminal! Play your friend, play the computer, or just sit back, relax and watch two computers battle to the finish!

<img src="https://github.com/msantam2/chess/blob/master/images/chess_play.gif" width="540" height="440" />

__________

### Run this Code

Play Chess in 3 simple steps! (You will need to have Ruby installed on your system)

1. run ```git clone https://github.com/msantam2/chess.git``` from the CLI

2. Navigate to your Chess directory and run ```bundle install``` for a beautiful looking board as well as keyboard I/O. ```cd lib/``` to enter the ```lib/``` directory

3. run ```ruby game.rb``` and you're off! (Zoom in on the terminal for clearer and better gameplay! (```cmd-shift-+```))

__________

### Playing the Game

First, you will be immediately prompted to select your choice of gameplay. Simply use the arrows on your keyboard to choose starting and ending locations for your pieces. You are prevented from selecting invalid starting and ending locations.
The cursor is represented by a gray background, and a selected piece with a green background.
To quit a game, press ```ctrl-C```.

__________

## Technologies

Chess is built with pure Ruby, displaying the principles of clean Object-Oriented Design. Each file contains only one class, utilizing class inheritance where appropriate to ensure DRY code. The ```colorize``` gem is used to render a beautiful chess board, along with the ```io/console``` gem in ```cursorable.rb``` to read standard input (```STDIN```).

## Implemention Details

### Modules

```Slideable``` and ```Stepable``` modules are leveraged to provide a ```moves``` method to each piece, according to its move behavior.

### Null Object Pattern

For empty spaces, a Null Object pattern is harnessed to provide DRY and easy-to-understand code. The NullPiece is instantiated (only once) with the following in order to integrate into the game logic:

```rb
def initialize
  @type = :nullpiece
  @color = nil
end
```

When a piece is successfully attacked, the NullPiece is set in its place:

```rb
def move_piece(start_pos, end_pos)
  piece = self[start_pos]
  self[start_pos] = NullPiece.instance
  self[end_pos] = piece
end
```

### Winning Condition

An intuitive check is done after each player's turn to assess whether or not the game has been won:

```rb
def game_won
  @board.flatten.none? do |piece|
    piece.type == :king && piece.color == @current_player.color
  end
end
```
The ```@board``` checks itself immediately after the game has switched players to see if the current player's king remains (if it does not, it has been captured by the previous player and the game is over)

### AI (Deep Dup)
