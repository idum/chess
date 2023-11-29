# This is the Rook class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour
require_relative "piece"
class Rook < Piece
    # King setting start with assign the right avatar (based by color)
    # and a position and setting
    # When the game will be created, istance will define starting position

    def initialize (color, position="out", status="start")
        color=="B" ? @avatar=BLACKROOK : @avatar=WHITEROOK
        set_color(color)
        @position = position
        @status = status
    end

    # We will define now one of the core method: the legal_move method
    # For a Rook, we have a general rule: rook can move any squars on his row or column
    # Special moves is castling: king and a tower can make a special move 
    # special constrain is: rook cannot jump over other piece
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


    