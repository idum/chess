# This is the King class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour
require_relative "piece"

class Bishop < Piece
    # King setting start with assign the right avatar (based by color)
    # and a position and setting
    # When the game will be created, istance will define starting position

    def initialize (color, position="out", status="start")
        color=="B" ? @avatar=BLACKBISHOP: @avatar=WHITEBISHOP
        set_color(color)
        @position = position
        @status = status
    end

    # We will define now one of the core method: the legal_move method
    # For a bishop, we have a general rule: bishop can move any squares in diagonal direction 
    # special constrain is: bishop cannot jump over other pieces
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # valuation of those element require the boardgame actual status

    # note: we will develop this part when we will complete the class Game

    def legal_move(start_location, move, position,distinguish_mark,captured,promotion,turn)
        super
        stcol,strow=start_location #decomposed col and row of piece start location
        trcol,trrow=move #decomposed col and row of piece target location
        #legal_move_list=[[stcol,strow+1]] if (strow<7) || !promotion.nil?


    end
end


    