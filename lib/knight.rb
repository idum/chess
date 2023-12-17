# This is the King class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour

require_relative "piece"
#require_relative "move"

class Knight < Piece
    # King setting start with assign the right avatar (based by color)
    # When the game will be created, istance will define starting position

    def initialize (params={})
        super
        @color=="B" ? @avatar=BLACKKNIGHT : @avatar=WHITEKNIGHT
    end

    # We will define now one of the core method: the legal_move method
    # 1) For a knight, we have a general rule: knight target move is an "L" two square in a line direction and one orthogonally
    # or viceversa. So we have max 8 possibile move squares for each knight. It can jump over any pieces
    # no special constrains (a part the movement, limited itself)
    # if the target square is occupied to friend piece, movement is impossible.
    # 2) if the target square is occupied to enemy piece, piece is captured. 
    # valuation of those element require the boardgame actual status

    def legal_move(move,coordinates=@coordinates)
        position=Game.position
        stcol,strow=coordinates #decomposed col and row of piece start location
        trcol,trrow=move.coordinates #decomposed col and row of piece target location
        #base test on position and piece color constrains
        return false if move.coordinates == coordinates
        return false if position[move.coordinates] && position[move.coordinates].color==@color
        return false if move.capture ^ position[move.coordinates]
        # 1) brutal mode: 8 test 
        if (mv_col(stcol,1)==trcol || mv_col(stcol,-1)==trcol)
            return true if mv_row(strow,2)==trrow || mv_row(strow,-2)==trrow 
        end
        if mv_col(stcol,2)==trcol || mv_col(stcol,-2)==trcol
            return true if mv_row(strow,1)==trrow || mv_row(strow,-1)==trrow 
        else
            return false
        end
    end
end


    