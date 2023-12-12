# This is the King class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour
require_relative "piece"
#require_relative "move"


class Bishop < Piece
    # Bishop setting start with assign the right avatar (based by color)
    def initialize (params={})
        super
        @color=="B" ? @avatar=BLACKBISHOP : @avatar=WHITEBISHOP
    end

    # We will define now one of the core method: the legal_move method
    # For a bishop, we have a general rule: bishop can move any squares in diagonal direction 
    # special constrain is: bishop cannot jump over other pieces
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # valuation of those element require the boardgame actual status

    def legal_move(move,coordinates=@coordinates)
        position=Move.position
        stcol,strow=coordinates #decomposed col and row of piece start location
        trcol,trrow=move.coordinates #decomposed col and row of piece target location
        #base test on position and piece color constrains
        return false if move.coordinates == coordinates
        return false if Move.position[move.coordinates] && Move.position[move.coordinates].color==@color
        return false if move.capture ^ Move.position[move.coordinates]
        col_distance=mv_distance(trcol,stcol)
        row_distance=mv_distance(trrow,strow)
        distance=col_distance.abs
        # diagonal movement check
        return false if col_distance.abs != row_distance.abs
        return !(1..distance-2).any? {|i| position[[mv_col(stcol,i),mv_row(strow,i)]]} if col_distance>0 && row_distance>0
        return !(1..distance-2).any? {|i| position[[mv_col(stcol,i),mv_row(strow,-i)]]} if col_distance>0 && row_distance<0
        return !(1..distance-2).any? {|i| position[[mv_col(stcol,-i),mv_row(strow,i)]]} if col_distance<0 && row_distance>0
        return !(1..distance-2).any? {|i| position[[mv_col(stcol,-i),mv_row(strow,-i)]]} if col_distance<0 && row_distance<0
        true
    end         
end


    