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
        @piecesym="N"
    end

    # We will define now one of the core method: the legal_move method
    # 1) For a knight, we have a general rule: knight target move is an "L" two square in a line direction and one orthogonally
    # or viceversa. So we have max 8 possibile move squares for each knight. It can jump over any pieces
    # no special constrains (a part the movement, limited itself)
    # if the target square is occupied to friend piece, movement is impossible.
    # 2) if the target square is occupied to enemy piece, piece is captured. 
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


    