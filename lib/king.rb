# This is the King class. 
# It is a Piece, so it use that minimal interface.
# Here we will define his behaviour

require_relative "piece"


class King < Piece
    # King setting start with assign the right avatar (based by color)
    # and a position and setting
    # When the game will be created, istance will define starting position

    def initialize (params={})
        super
        @color=="B" ? @avatar=BLACKKING : @avatar=WHITEKING
    end
    # We will define now one of the core method: the legal_move method
    # For a king, we have a general rule: king can move one square in any direction
    # Special moves is castling: king and a tower can make a special move if 
    # special constrain is: king cannot move himself under enemy piece threat 
    # a square is under enemy threat if an enemy piece can move in that square.
    # note: piece that is in the target move location don't create threat
    # if the target square is occupied to friend piece, movement is impossible.
    # if the target square is occupied to enemy piece, piece is captured.
    # note: king cannot capture enemy pieces if the move put the king in a square where persist an enemy threat
    # valuation of those element require the boardgame actual status

    def legal_move(move,coordinates=@coordinates)
        position=Move.position
        stcol,strow=coordinates #decomposed col and row of piece start location
        trcol,trrow=move.coordinates #decomposed col and row of piece target location
        #castling is a very special move and it use a different protocol
        case move.castling 
        when ""
            #base test on position and piece color constrains
            return false if move.coordinates == coordinates
            return false if Move.position[move.coordinates] && Move.position[move.coordinates].color==@color
            return false if move.capture ^ Move.position[move.coordinates]
            # check if the move is at 1 square
            return false if mv_distance(stcol,trcol).abs>1 || mv_distance(strow,trrow).abs>1
            # check if in a move (capture or not) target square is threatened by enemy pieces
            return !move.threatened_square(move.coordinates,@color)
        when "short" 
            @color=="W" ? castling_row="1" : castling_row="8"
            # king constrain
            return false if Move.position[["e",castling_row]].class!=King || Move.position[["e",castling_row]].status=="moved"
            # rook constrain 
            return false if Move.position[["h",castling_row]].class!=Rook || Move.position[["h",castling_row]].status=="moved"
            # threaten squares
            return !("e".."g").any? {|col| move.threatened_square([col,castling_row],@color)}
        when "long"
            @color=="W" ? castling_row="1" : castling_row="8"
            # king constrain
            return false if Move.position[["e",castling_row]].class!=King || Move.position[["e",castling_row]].status=="moved"
            # rook constrain 
            return false if Move.position[["a",castling_row]].class!=Rook || Move.position[["a",castling_row]].status=="moved"
            # threaten squares
            return !("c".."e").any? {|col| move.threatened_square([col,castling_row],@color)}
        end
    end
end


    