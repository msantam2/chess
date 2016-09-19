## Chess

### Background

Chess is a game we all know and love, but have you ever wanted to boot up the terminal and play directly in the console of your computer? Well, now you can, with the aptly named 'Chess'.

The only requirement to play...
<br>
<br>
Enjoy!

### Functionality & MVP

The Minimum Viable Product will include the following features:

- Terminal-based GUI
- Move validation/check/checkmate
- Computer AI (avoids check/checkmate & puts opponent in check/checkmate, makes high-value trades)
- Implements advanced moves (en passant, castling)

### Wireframes

<img src="https://github.com/msantam2/chess/blob/master/images/chess.png" width="400" height="600" />

### Technologies

This game of chess will be built with raw Ruby code, displaying the core tenets and power of Object-Oriented Programming. There will be no more than 1 class per file, keeping the program very modular and modifiable.

A `Game` class will handle the business logic of overall gameplay.
<br>
A `Board` will contain the grid, rendering Unicode chess pieces to create a fun and accurate view of a chess board.
<br>
All of the chess pieces will be subclasses of `Piece`, and depending on their behavior will either mix-in a `Slideable` or `Stepable` module (with the Queen mixing-in both).

A challenge of building this game will be incorporating both the computer's AI and advanced move capabilities.

### Implementation Timeline

**Day 1**: Get started on the `Game` and `Board` classes, rendering a grid with checkered spots and Unicode chess pieces.

- A completed `game.rb` and `board.rb`

**Day 2**: Work on UI: allowing the user to navigate the board with the keyboard. Implement:

- The ability to start playing and move pieces to valid positions
- Each move checks for check/checkmate conditions

**Day 3**: Dedicate to the computer AI:

- The computer avoids fatal check/checkmate moves
- When given the opportunity, the computer forces the opponent into check/checkmate
- Computer makes high-value trades when given the chance (i.e. pawn for bishop)

**Day 4**: Devote last day to incorporating advanced moves:

- En passant
- Castling

Finally, allow to the user to play again when the game has ended.
