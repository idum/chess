# This is the King class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour
require_relative "piece"

class Bishop < Piece
    # Bishop setting start with assign the right avatar (based by color)
    def initialize (params={})
        super
        @color=="B" ? @avatar=BLACKBISHOP : @avatar=WHITEBISHOP
        @piecesym="B"
    end

    # We will define now one of the core method: the legal_move method
    # For a bishop, we have a general rule: bishop can move any squares in diagonal direction 
    # special constrain is: bishop cannot jump over other pieces
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # valuation of those element require the boardgame actual status

    def legal_move(square_to,square_from,params={})
        capture=params.fetch(:capture,false)
        position=Game.position
        stcol,strow=square_from #decomposed col and row of piece start location
        trcol,trrow=square_to #decomposed col and row of piece target location
        #base test on position and piece color constrains
        return false if square_from == square_to
        return false if position[square_to] && position[square_to].color==@color
        return false if capture ^ position[square_to]
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


    