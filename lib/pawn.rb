# This is the Pawn class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour

require_relative "piece"

class Pawn < Piece
    # Color is the color piece "W" white or "B" black
    # Status can be: "start" in setup phase, "game" when in game, "captured", when captured, "promoted", when promoted, (last two for future features), 
    #  and turn when/if pawn made first double move, for en-passant special move.
    # 
    

    def initialize (params={})
        super
        @color=="B" ? @avatar=BLACKPAWN : @avatar=WHITEPAWN
        @piecesym="P"
    end

    # We will define now one of the core method: the legal_move method
    # For a pawn, we have a general rule: pawn can move one square on his column, direction depend of color:
    # 1) for white pawns move is a square up (es e4 -> e5), for black pawns, move is one square down (es e5 -> e4)
    # 2) Special moves is double move: if pawn is not moved, it can move 2 squares NOTE: pawn status will report the move when/if it happens 
    #    for compute EN PASSANT
    # 3) special constrain is: pawn cannot move in an occupied square
    # 4) capturing move is special: a pawn can make a special diagonal move (up or down depending of color)
    #    move is possible only if there is an enemy piece and it cause capturing the piece
    # 5) EN PASSANT is another special move: a pawn can make a capturing move if happens:
    #    in the precedent turn an enemy pawn make a double move and the arriving square is adjacent to actual pawn
    #    in this case, actual pawn can move diagonally and capture the enemy pawn as if the enemy pawn moved only one square
    #    example: enemy pawn in d7, actual pawn in e5. If in the precedent turn enemy pawn makes a double move: d7->d5
    #    in the successive turn (and only in the successive turn), pawn can move e5->d6 and capture the pawn in d5.
    #    valuation of those element require the boardgame actual status
    # 6) promotion, when a pawn reach the last row (8 for the white and 1 for the black). In this case, the pawn will be substitute with another
    #    piece. The piece is defined by the move. Ex: b8=Q means that the pawn will be promoted in a Queen
    #
   
    def legal_move(square_to,square_from,params={})
        capture=params.fetch(:capture,false)
        promotion_piece=params.fetch(:promotion_piece, nil)
        castling=params.fetch(:castling,"")    
        position=Game.position
        stcol,strow=square_from #decomposed col and row of piece start location
        trcol,trrow=square_to #decomposed col and row of piece target location
        #basic test: movement in the same position 
        return false if square_from == square_to
        if (((mv_col(stcol,1)==trcol) || ((mv_col(stcol,-1)==trcol))) && capture) # capturing moves have to be right or left side
            case @color
                in "W"
                    return true if strow.match?(/[2-6]/) && (mv_row(strow,1)==trrow) && 
                                   position[square_to] && position[square_to].color=="B" #4)
                    return true if strow=="5" && trrow=="6" && position[[trcol,"5"]] && 
                                   position[[trcol,"5"]].class==Pawn && position[[trcol,"5"]].color=="B" &&
                                   (position[[trcol,"5"]].status.to_i + 1)== Game.actual_turn #5)
                    return true if promotion_piece && strow=="7" && trrow=="8" && 
                                   position[square_to] && position[square_to].color=="B"# 6) promotion while capturing a piece
                in "B"
                    return true if strow.match?(/[3-7]/) && (mv_row(strow,-1)==trrow) && 
                                   position[square_to] && position[square_to].color=="W" #4)
                    return true if strow=="4" && trrow=="3" && position[[trcol,"4"]] && 
                                   position[[trcol,"4"]].class==Pawn &&  position[[trcol,"4"]].color="W" && 
                                   (position[[trcol,"4"]].status.to_i)== Game.actual_turn #5))
                    return true if promotion_piece && strow=="2" && trrow=="1" && 
                                   position[square_to] && position[square_to].color=="W"# 6) promotion while capturing a piece
            end
        end
        if (!capture && !position[square_to]) #not capturing moves. Target square have to be empty
            case @color
                in "W" 
                    return true if (mv_row(strow,2)==trrow) && (stcol==trcol) && strow=="2" && !position[[stcol,"3"]] #2)
                    return true if (mv_row(strow,1)==trrow) && (stcol==trcol) && strow.match?(/[2-6]/)  #1)
                    return true if stcol==trcol && trrow=="8" && promotion_piece && strow=="7" # 6) 
                in "B" 
                    return true if (mv_row(strow,-2)==trrow) && (stcol==trcol) && strow=="7" && !position[[stcol,"6"]] #2)              
                    return true if (mv_row(strow,-1)==trrow) && (stcol==trcol) && strow.match?(/[3-7]/) #1)          
                    return true if stcol==trcol && trrow=="1" && promotion_piece && strow=="2"# 6)             
            end
        end
        return false
    end

    def try_move(square_to,square_from,test=true, params={})
        promotion_piece = params.fetch(:promotion_piece, nil)
        old_position=Game.position.clone
        Game.position.delete([square_to[0],square_from[1]]) if Game.position[[square_to[0],square_from[1]]] && 
                                                               Game.position[[square_to[0],square_from[1]]].class==Pawn &&
                                                               square_from[0]!=square_to[0] && square_from[1]!=square_to[1]
        Game.position.delete(square_from)
        promotion_piece ? Game.position[square_to]=Move::CHESS_DICTIONARY[promotion_piece].new(color: @color) : Game.position[square_to]=self
        if Game.check_condition(self.color)
            Game.position=old_position
            return false
        end
        Game.position=old_position if test
        self.status=Game.actual_turn.to_s if color=="W" && square_from[1]=="2" && square_to[1]=="4" && !test
        self.status=Game.actual_turn.to_s if color=="B" && square_from[1]=="7" && square_to[1]=="5" && !test
        true
    end
end
    