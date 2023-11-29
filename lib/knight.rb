# This is the King class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour

require_relative "piece"

class Knight < Piece
    # King setting start with assign the right avatar (based by color)
    # and a position and setting
    # When the game will be created, istance will define starting position

    def initialize (color, position="out", status="start")
        color=="B" ? @avatar=BLACKKNIGHT : @avatar=WHITEKNIGHT
        set_color(color)
        @position = position
        @status = status
    end

    # We will define now one of the core method: the legal_move method
    # For a knight, we have a general rule: knight target move is an "L" two square in a line direction and one orthogonally
    # or viceversa. So we have max 8 possibile move squares for each knight. It can jump over any pieces
    # no special constrains (a part the movement, limited itself)
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # valuation of those element require the boardgame actual status

    # note: we will develop this part when we will complete the class Game

    def legal_move(start_location, move, position,distinguish_mark,captured,promotion,turn)
        super
        #legal_move_list=[[stcol,strow+1]] if (strow<7) || !promotion.nil?


    end
end


    