# This is the Queen class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour

require_relative "piece"


class Queen < Piece
    # Queen setting start with assign the right avatar (based by color)
    # and a position and setting
    # When the game will be created, istance will define starting position

    def initialize (params={})
        super
        @color=="B" ? @avatar=BLACKKNIGHT : @avatar=WHITEKNIGHT
    end

    # We will define now one of the core method: the legal_move method
    # For a queen, we have a general rule: queen can move any squares in line in any direction
    # special constrain is: queen cannot jump over other pieces
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # valuation of those element require the boardgame actual status

    # note: we will develop this part when we will complete the class Game

    def legal_move(move,coordinates=@coordinates)
        position=Game.position
        stcol,strow=coordinates #decomposed col and row of piece start location
        trcol,trrow=move.coordinates #decomposed col and row of piece target location
        #base test on position and piece color constrains
        return false if move.coordinates == coordinates
        return false if Game.position[move.coordinates] && Game.position[move.coordinates].color==@color
        return false if move.capture ^ Game.position[move.coordinates]
        col_distance=mv_distance(trcol,stcol)
        row_distance=mv_distance(trrow,strow)
        distance=col_distance.abs
        # orthogonal or diagonal movement check
        #return false if ((stcol==trcol) == (strow==trrow)) ^ (col_distance.abs != row_distance.abs)
        # movement along row
        if (stcol==trcol) != (strow==trrow)
            return !(mv_row(trrow,1)...strow).any? {|row| position[[stcol,row]]} if strow>trrow
            return !(mv_row(strow,1)...trrow).any? {|row| position[[stcol,row]]} if strow<trrow
            return !(mv_col(stcol,1)...trcol).any? {|col| position[[col,strow]]} if stcol<trcol
            return !(mv_col(trcol,1)...stcol).any? {|col| position[[col,strow]]} if stcol>trcol
        elsif (col_distance.abs == row_distance.abs)
            return !(1..distance-2).any? {|i| position[[mv_col(stcol,i),mv_row(strow,i)]]} if col_distance>0 && row_distance>0
            return !(1..distance-2).any? {|i| position[[mv_col(stcol,i),mv_row(strow,-i)]]} if col_distance>0 && row_distance<0
            return !(1..distance-2).any? {|i| position[[mv_col(stcol,-i),mv_row(strow,i)]]} if col_distance<0 && row_distance>0
            return !(1..distance-2).any? {|i| position[[mv_col(stcol,-i),mv_row(strow,-i)]]} if col_distance<0 && row_distance<0
        end
        false             
    end
end


    