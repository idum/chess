# This is the Queen class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour
class Queen < Piece
    # Queen setting start with assign the right avatar (based by color)
    # and a position and setting
    # When the game will be created, istance will define starting position

    def initialize (color, position="out", status="start")
        color=="B" ? @avatar=BLACKQUEEN : @avatar=WHITEQUEEN
        set_color(color)
        @position = position
        @status = status
    end

    # We will define now one of the core method: the legal_move method
    # For a queen, we have a general rule: queen can move any squares in line in any direction
    # special constrain is: queen cannot jump over other pieces
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # valuation of those element require the boardgame actual status

    # note: we will develop this part when we will complete the class Game

    def legal_move(move,board)
        true
    end
end


    