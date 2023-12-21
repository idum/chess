# This is the Rook class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour
require_relative "piece"
#require_relative "move"

class Rook < Piece
    # Rook setting start with assign the right avatar (based by color)
     
    def initialize (params={})
        super
        @color=="B" ? @avatar=BLACKROOK : @avatar=WHITEROOK
    end

    # We will define now one of the core method: the legal_move method
    # For a Rook, we have a general rule: rook can move any squars on his row or column
    # Special moves is castling: king and a tower can make a special move, but it is governed by King class
    # standard constrain is: rook cannot jump over other piece
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # valuation of those element require the boardgame actual status

    def legal_move(square_to,square_from,params={})
        capture=params.fetch(:capture,false)
        promotion_piece=params.fetch(:promotion_piece,"")
        castling=params.fetch(:castling,"")
        position=Game.position
        stcol,strow=square_from #decomposed col and row of piece start location
        trcol,trrow=square_to #decomposed col and row of piece target location
        #base test on position and piece color constrains
        return false if square_from == square_to
        return false if position[square_to] && position[square_to].color==@color
        return false if capture ^ position[square_to]
        # orthogonal movement check
        return false if (stcol==trcol) == (strow==trrow)
        # movement along row
        return !(mv_row(trrow,1)...strow).any? {|row| position[[stcol,row]]} if strow>trrow
        return !(mv_row(strow,1)...trrow).any? {|row| position[[stcol,row]]} if strow<trrow
        return !(mv_col(stcol,1)...trcol).any? {|col| position[[col,strow]]} if stcol<trcol
        return !(mv_col(trcol,1)...stcol).any? {|col| position[[col,strow]]} if stcol>trcol
        true                
    end
end


    