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
        @piecesym="K"
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

    def legal_move(square_to,square_from,params={})
        capture=params.fetch(:capture,false)
        castling=params.fetch(:castling,"")
        position=Game.position
        stcol,strow=square_from #decomposed col and row of piece start location
        trcol,trrow=square_to #decomposed col and row of piece target location
        #castling is a very special move and it use a different protocol
        case castling 
        when ""
            #base test on position and piece color constrains
            return false if square_from == square_to
            return false if position[square_to] && position[square_to].color==@color
            return false if capture ^ position[square_to]
            # check if the move is at 1 square
            return false if mv_distance(stcol,trcol).abs>1 || mv_distance(strow,trrow).abs>1
            # check if in a move (capture or not) target square is threatened by enemy pieces
            return !Game.threatened_square(square_to,@color)
        when "short" 
            @color=="W" ? castling_row="1" : castling_row="8"
            # king constrain
            return false if position[["e",castling_row]].class!=King || position[["e",castling_row]].status=="moved"
            # rook constrain 
            return false if position[["h",castling_row]].class!=Rook || position[["h",castling_row]].status=="moved"
            # threaten squares
            return !("e".."g").any? {|col| Game.threatened_square([col,castling_row],@color)}
        when "long"
            @color=="W" ? castling_row="1" : castling_row="8"
            # king constrain
            return false if position[["e",castling_row]].class!=King || position[["e",castling_row]].status=="moved"
            # rook constrain 
            return false if position[["a",castling_row]].class!=Rook || position[["a",castling_row]].status=="moved"
            # threaten squares
            return !("c".."e").any? {|col| Game.threatened_square([col,castling_row],@color)}
        end
    end

    def try_move(square_to,square_from,test=true, params={})
        castling=params.fetch(:castling, "")
        old_position=Game.position.clone
        king,rook=nil
        case castling
        when ""
            Game.position.delete(square_from)
            Game.position[square_to]=self
        when "short"
            case color
            when "B"
                king=Game.position.delete(["e","8"])
                rook=Game.position.delete(["h","8"])
                Game.position[["g","8"]]=king
                Game.position[["f","8"]]=rook
            when "W"
                king=Game.position.delete(["e","1"])
                rook=Game.position.delete(["h","1"])
                Game.position[["g","1"]]=king
                Game.position[["f","1"]]=rook
            end
        when "long"
            case color
            when "B"
                king=Game.position.delete(["e","8"])
                rook=Game.position.delete(["a","8"])
                Game.position[["c","8"]]=king
                Game.position[["d","8"]]=rook
            when "W"
                king=Game.position.delete(["e","1"])
                rook=Game.position.delete(["a","1"])
                Game.position[["c","1"]]=king
                Game.position[["d","1"]]=rook
            end
        end

        if Game.check_condition(self.color)
            Game.position=old_position
            return false
        end
        Game.position=old_position if test
        king.status="moved" if king
        rook.status="moved" if rook
        true
    end
end


    