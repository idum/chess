# This is the King class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour

require_relative "piece"
class King < Piece
    # King setting start with assign the right avatar (based by color)
    # and a position and setting
    # When the game will be created, istance will define starting position

    def initialize (color, position="out", status="start")
        color=="B" ? @avatar=BLACKKING : @avatar=WHITEKING
        set_color(color)
        @position = position
        @status = status
    end

    # We will define now one of the core method: the legal_move method
    # For a king, we have a general rule: king can move one square in any direction
    # Special moves is castling: king and a tower can make a special move if 
    # special constrain is: king cannot move himself under enemy piece threat 
    # a square is under enemy threat if an enemy piece can move in that square.
    # note: piece that is in the target move location don't create threat
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # note: king cannot capture enemy pieces if the move put the king in a square where persist an enemy threat
    # valuation of those element require the boardgame actual status

    # note: we will develop this part when we will complete the class Game

    def legal_move(move,board)
        true
    end
end


    