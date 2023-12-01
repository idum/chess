# This is the Pawn class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour

require_relative "piece"
class Pawn < Piece
    # Color is the color piece "W" white or "B" black
    # Status can be: "start" in setup phase, "game" when in game, "captured", when captured, "promoted", when promoted, (last two for future features), 
    #  and turn when/if pawn made first double move, for en-passant special move.
    # 
    

    def initialize (color, status="start")
        color=="B" ? @avatar=BLACKPAWN : @avatar=WHITEPAWN
        @color=color
        @status = status
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
    # 

    # note: we will develop this part when we will complete the class Game


    def legal_move(move,piece_coord)
        super
        position=Move.position
        stcol,strow=piece_coord #decomposed col and row of piece start location
        trcol,trrow=move.coordinates #decomposed col and row of piece target location
        return false if position[move.coordinates] && !move.capture #3)
        move_list=[]
        case @color
        when "W"
            move_list+=[[stcol,mv_row(strow,1)]] if (strow.to_i<7) || move.promote=="" # 1)
            move_list+=[[stcol,mv_row(strow,2)]] if strow.to_i==2 #2)
            move_list+=[[mv_col(stcol,1),mv_row(strow,1)]] if (move.capture && 
                                                            position[mv_col(stcol,1),mv_row(strow,1)] &&
                                                            position[mv_col(stcol,1),mv_row(strow,1)].color=="B") #4)
            move_list+=[[mv_col(stcol,-1),mv_row(strow,1)]] if (move.capture && 
                                                            position[mv_col(stcol,-1),mv_row(strow,1)] && 
                                                            position[mv_col(stcol,-1),mv_row(strow,1)].color=="B") #4)
            move_list+=[[mv_col(stcol,1),mv_row(strow,1)]] if (move.capture &&
                                                            position[mv_col(stcol,1),strow] &&
                                                            position[mv_col(stcol,1),strow].color=="B" &&
                                                            position[mv_col(stcol,1),strow].class==Pawn &&
                                                            position[mv_col(stcol,1),strow].status.to_i==Move.actual_turn-1) #5)
            
            move_list+=[[mv_col(stcol,-1),mv_row(strow,1)]] if (captured &&
                                                                position[mv_col(stcol,-1),strow] &&
                                                                position[mv_col(stcol,-1),strow].color=="B" &&
                                                                position[mv_col(stcol,-1),strow].class==Pawn &&
                                                                position[mv_col(stcol,-1),strow].status.to_i==Move.actual_turn-1) #5)
        when "B"
            move_list+=[[stcol,mv_row(strow,-1)]] if (strow.to_i>1) || !move.promote=="" # 1)
            move_list+=[[stcol,mv_row(strow,-2)]] if strow.to_i==7 #2)
            move_list+=[[mv_col(stcol,1),mv_row(strow,-1)]] if (move.capture && 
                                                            position[mv_col(stcol,1),mv_row(strow,-1)] &&
                                                            position[mv_col(stcol,1),mv_row(strow,-1)].color=="B") #4)
            move_list+=[[mv_col(stcol,-1),mv_row(strow,-1)]] if (move.capture && 
                                                            position[mv_col(stcol,-1),mv_row(strow,-1)] && 
                                                            position[mv_col(stcol,-1),mv_row(strow,-1)].color=="B") #4)
            move_list+=[[mv_col(stcol,1),mv_row(strow,-1)]] if (move.capture &&
                                                            position[mv_col(stcol,1),strow] &&
                                                            position[mv_col(stcol,1),strow].color=="B" &&
                                                            position[mv_col(stcol,1),strow].class==Pawn &&
                                                            position[mv_col(stcol,1),strow].status.to_i==Move.actual_turn-1) #5)
            
            move_list+=[[mv_col(stcol,-1),mv_row(strow,-1)]] if (move.capture &&
                                                                position[mv_col(stcol,-1),strow] &&
                                                                position[mv_col(stcol,-1),strow].color=="B" &&
                                                                position[mv_col(stcol,-1),strow].class==Pawn &&
                                                                position[mv_col(stcol,-1),strow].status.to_i==Move.actual_turn-1) #5)
        end
        return true if move_list.any?(move)
        return false                                   
    end
end


    