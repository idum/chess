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

    def legal_move(move,coordinates=@coordinates)
        position=Game.position
        stcol,strow=coordinates #decomposed col and row of piece start location
        trcol,trrow=move.coordinates #decomposed col and row of piece target location
        #base test on position and piece color constrains
        return false if move.coordinates == coordinates
        return false if Game.position[move.coordinates] && Game.position[move.coordinates].color==@color
        return false if move.capture ^ Game.position[move.coordinates]
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


    