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


class Move 

    CHESS_DICTIONARY = {"K" => King, "Q" => Queen, "R" => Rook, "B" => Bishop, "N" => Knight, "P" => Pawn, "0" => Piece}
    
    attr_accessor :square_from, :square_to, :piece_sym, :capture, :promote, :castling, :spec, :piece

    def initialize(move_to_parse,in_game=true)
        Game.error=""
        Game.status="game"
        @capture=false
        @castling=""
        @spec=""
        @promote=nil
        parser(move_to_parse)
        legal_move if Game.error=="" && in_game
        try_move if Game.error=="" && in_game
        Game.save_move(move_to_parse) if Game.error=="" && in_game
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
                Game.who_move=="B" ? Game.status=" BLACK RESIGN!" : Game.status= " WHITE RESIGN!"
                return Game.error="endgame"
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
            return Game.error= "Error: Move not recognized"           
        end       
        return Game.error = "Error: wrong column" if col && !col.match?(/[a-h]/)
        return Game.error = "Error: wrong row" if row && !row.match?(/[1-8]/)
        @square_to=[col,row]
        @piece_sym=piece_sym
        @spec=spec
        @promote=promote 
    end

    # legal_move find the piece that can do the move and test if the move is possible
    # if the move is not possible, it return "" that raise an ErrMoveError
    # if it is possible, it will generate a status that can be "game", normally, or one of end_game flags
    def legal_move

        candidates=Game.position.select { |coord,piece| 
            piece.piecesym==@piece_sym &&
            piece.color==Game.who_move &&
            piece.legal_move(@square_to,coord,promotion_piece: @promote, capture: @capture, castling: @castling) &&
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
 
        return Game.error = "Error: Move is not possible" if candidates.size==0 #No piece can do the move
        return Game.error = "Error: Move is ambiguous" if candidates.size>1 #not recognized what piece have to move  
        @piece=candidates.values[0]
        @square_from=candidates.keys[0]
    end

    def try_move
        return Game.error = "Error: King is on check" if !@piece.try_move(@square_to,@square_from, test=false, castling: @castling, promotion_piece: @promote)
    end
end





        
    










