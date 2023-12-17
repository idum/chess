# 1st refactor. Class move rapresent the move-manager. 
# it is an useful collector for all the informations of actual move
# and it have methods for verify the correctness of the move.

# we insert a class for manage bad move error
require_relative "pawn"
require_relative "knight"
require_relative "rook"
require_relative "bishop"
require_relative "queen"
require_relative "king"
require_relative "piece"
require_relative "game"


class BadMoveError < RuntimeError; end
class ErrMoveError < RuntimeError; end

class Move 

    CHESS_DICTIONARY = {"K" => King, "Q" => Queen, "R" => Rook, "B" => Bishop, "N" => Knight, "P" => Pawn, "0" => Piece}
    
    attr_accessor :coordinates, :piece_sym, :capture, :promote, :castling, :spec

    def initialize(move_to_parse)
        @capture=false
        @castling=""
        @spec=""
        @promote=""
        parser(move_to_parse)
        return Game.status if Game.status !="game"
    end

    # Here follows class method for obtain status of the game: 
       
    # method parser (perhaps private) examine the move, and separe the target square, the Piece that have to do the move
    # and eventual other elements: capture flag, promotion piece, a specify element for resolve move conflicts, 
    # and a special container for long and short castling.
    # parser return an error message "The Move is not Recognized" if the parsing is not correct or if the move is outside the board.

    def parser(move_to_parse)
        # part 1: verify syntactically correct moves. Move is correct if
        # a) is "resign" word
        # b) is "o-o" or "O-O" or "o-o-o" or "O-O-O" for castling special move
        # c) standard notation: [QKRBN][col][row] : Qe4 (note: the Knight is indicated by N)
        # d) standard notation for pawn move, in this case P is not used: [col][row] : e4
        # e) standard notation for a capturing move: [QKRBN]x[col][row] : Rxg4
        # f) standard notation for a capturing pawn move: [col]x[col][row] : dxe4
        # g) variant notation when two same type pieces can reach the same space, 
        #    we add start col/row for distinguish : Rfg4 or R4g5 or Rfxg4
        # h) special promotion move when the Pawn will promote in another piece: d8=D
        # i) check and checkmate symbols are ignored in the input, they will be add in the move_stack record if needing
        mv=move_to_parse.split("")
        mv.pop if mv[-1].match?(/[\+\#]/)
        case mv 
            in ["r","e","s","i","g","n"] 
                return Game.status="Game Resigned"
            in ["o","-","o"] | ["O","-","O"] 
                piece_sym = "K"
                @castling = "short"
                @capture=false
            in ["o","-","o","-","o"] | ["O","-","O","-","O"]
                piece_sym = "K"
                @castling="long"
                @capture=false
            in [piece_sym,col,row] if CHESS_DICTIONARY.keys.include?(piece_sym)
                @capture=false
            in [col,row]
                piece_sym="P"
            in [piece_sym,"x",col,row] if CHESS_DICTIONARY.keys.include?(piece_sym)
                @capture=true
            in [spec,"x",col,row] if spec.match?(/[a-h]/)
                piece_sym="P"
                @capture=true
            in [colp,rowp,"x",col,row] if (colp.match?(/[a-h]/) && rowp.match?(/[1-8]/))
                piece_sym="P"
                @capture=true
                spec=colp+rowp
            in [piece_sym,colp,rowp,col,row] if (colp.match?(/[a-h]/) && rowp.match?(/[1-8]/) && CHESS_DICTIONARY.keys.include?(piece_sym))
                @capture=false
                spec=colp+rowp
            in [piece_sym,colp,rowp,"x",col,row] if (colp.match?(/[a-h]/) && rowp.match?(/[1-8]/) && CHESS_DICTIONARY.keys.include?(piece_sym))
                @capture=true
                spec=colp+rowp
            in [piece_sym, spec,col,row] if (spec.match?(/[a-h]|[1-8]/) && CHESS_DICTIONARY.keys.include?(piece_sym))
                @capture=false
            in [piece_sym, spec,"x",col,row] if (spec.match?(/[a-h]|[1-8]/) && CHESS_DICTIONARY.keys.include?(piece_sym))
                @capture=true
            in [col,row,"=",promote] if (CHESS_DICTIONARY.keys.include?(promote) && row.match?(/[18]/))
                piece_sym="P"
                @capture=false
            in [spec,"x",col,row,"=",promote] if (row.match?(/[18]/) && spec.match?(/[a-h]|[1-8]/) && CHESS_DICTIONARY.keys.include?(promote))
                piece_sym="P"
                @capture=true
        else 
            return Game.status= "Error: Move not recognized"           
        end       
        return Game.status = "Error: wrong column" if col && !col.match?(/[a-h]/)
        return Game.status = "Error: wrong row" if row && !row.match?(/[1-8]/)
        @coordinates=[col,row]
        @piece_sym=piece_sym
        @spec=spec
        @promote=promote
    end

    # legal_move find the piece that can do the move and test if the move is possible
    # if the move is not possible, it return "" that raise an ErrMoveError
    # if it is possible, it will generate a status that can be "game", normally, or one of end_game flags
    def legal_move
        candidates=Game.position.select { |coord,piece| 
            piece.class==CHESS_DICTIONARY[@piece_sym] &&
            piece.color==Game.who_move &&
            piece.legal_move(self,coord) &&
            case @spec
            when /[a-h][1-8]/
                coord==@spec.split("")
            when /[1-8]/
                coord[1]==@spec
            when /[a-h]/
                coord[0]==@spec
            else
                true
            end
        }
        return Game.status = "Error: Move is not possible" if candidates.size==0 #No piece can do the move
        return Game.status = "Error: Move is ambiguous" if candidates.size>1 #not recognized what piece have to move  
        return candidates.keys[0]
    end

    def make_move(square_from)
        piece=Game.position[square_from]
        color=Game.who_move
        last_position=Game.position
        case @castling
        when ""
            piece.status="moved"
            #2-square pawn special move test, for en-passant flag status
            if piece.class==Pawn
                piece.status=Game.actual_turn.to_s if color=="W" && square_from[1]=="2" && @coordinates[1]=="4"
                piece.status=Game.actual_turn.to_s if color=="B" && square_from[1]=="7" && @coordinates[1]=="5"
            end
            Game.position.delete(square_from)
            Game.position[@coordinates]=piece
        when "short"
            case color
            when "B"
                king=Game.position.delete(["e","8"])
                rook=Game.position.delete(["h","8"])
                king.status="moved"
                rook.status="moved"
                Game.position[["g","8"]]=king
                Game.position[["f","8"]]=rook
            when "W"
                king=Game.position.delete(["e","1"])
                rook=Game.position.delete(["h","1"])
                king.status="moved"
                rook.status="moved"
                Game.position[["g","1"]]=king
                Game.position[["f","1"]]=rook
            end
        when "long"
            case color
            when "B"
                king=Game.position.delete(["e","8"])
                rook=Game.position.delete(["a","8"])
                king.status="moved"
                rook.status="moved"
                Game.position[["c","8"]]=king
                Game.position[["d","8"]]=rook
            when "W"
                king=Game.position.delete(["e","1"])
                rook=Game.position.delete(["a","1"])
                king.status="moved"
                rook.status="moved"
                Game.position[["c","1"]]=king
                Game.position[["d","1"]]=rook
            end
        end
        king=Game.position.select {|pos,piece|
            piece.class==King &&
            piece.color==color        
        }
        
        if threatened_square(king.keys[0])
            Game.position=last_position
            return Game.status="King is on check!" #King is under check after the move, so the move is not correct
        end
        return true
    end
   


    # threatened_square is a key method. A square is threatened if there is at least an enemy piece that
    # can execute a capture move in that square if in this square there is a piece.
    # this is useful for king movement: infact, if king is in a threatened square, there are possible only
    # moves that avoid threat. If there are no moves, king is checkmated and game end with opponent victory
    # The method is also useful, for king movements. Infact King cannot move or make a capture move in a threatened_square.
    # King cannot also make a castling if king is threatened or is threatened one of the king-castling

    def threatened_square(square,color=Game.who_move)
        oldpiece=Game.position[square]
        Game.position[square]=Piece.new(color: color)        
        a=Game.position.any? {|pos,piece|
            string_move=(CHESS_DICTIONARY.key(piece.class) + "x" + square[0]+square[1]) 
            piece.legal_move(Move.new(string_move),pos)
        }
        oldpiece ? Game.position[square]=oldpiece :  Game.position.delete(square)
        return a        
    end
end





        
    










