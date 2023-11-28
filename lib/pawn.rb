# This is the Pawn class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour

require_relative "piece"
class Pawn < Piece
    # King setting start with assign the right avatar (based by color)
    # and a position and setting
    # When the game will be created, istance will define starting position

    def initialize (color, position="out", status="start")
        color=="B" ? @avatar=BLACKPAWN : @avatar=WHITEPAWN
        set_color(color)
        @position = position
        @status = status
    end

    # We will define now one of the core method: the legal_move method
    # For a pawn, we have a general rule: pawn can move one square on his column, direction depend of color:
    # for white pawns move is a square up (es e4 -> e5), for black pawns, move is one square down (es e5 -> e4)
    # Special moves is double move: if pawn is not moved, it can move 2 squares 
    # special constrain is: pawn cannot move in an occupied square
    # capturing move is special: a pawn can make a special diagonal move (up or down depending of color)
    # move is possible only if there is an enemy piece and it cause capturing the piece
    # EN PASSANT is another special move: a pawn can make a capturing move if happens:
    # in the precedent turn an enemy pawn make a double move and the arriving square is adjacent to actual pawn
    # in this case, actual pawn can move diagonally and capture the enemy pawn as if the enemy pawn moved only one square
    # example: enemy pawn in d7, actual pawn in e5. If in the precedent turn enemy pawn makes a double move: d7->d5
    # in the successive turn (and only in the successive turn), pawn can move e5->d6 and capture the pawn in d5.
    # valuation of those element require the boardgame actual status

    # note: we will develop this part when we will complete the class Game

    def legal_move(move,board)
        true
    end
end


    