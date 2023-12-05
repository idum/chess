# 1st refactor. Class move rapresent the move-manager. 
# it is an useful collector for all the informations of actual move
# and it have methods for verify the correctness of the move.

# we insert a class for manage bad move error

class BadMoveError < RuntimeError; end
class ErrMoveError < RuntimeError; end

class Move 

    CHESS_DICTIONARY = {"K" => King, "Q" => Queen, "R" => Rook, "B" => Bishop, "N" => Knight, "P" => Pawn}
    
    #Class variables for record the status of the game
    # @@position is a collection of hash in the form {[col,row] => Piece} and show the position of the pieces on the board in actual turn
    @@position={}
    # @@game_history is an array of Hash, in the form {s_move => @@position} where s_move is a string and @@position is the position after the move.
    @@game_history=[]
    # @@status is a string and it show the status of the game: actually "game" or end_game conditions for graphical output pourpose
    @@status="game"

    attr_reader :coordinates, :piece, :capture, :promote, :castling, :spec

    def initialize(actual_move)
        @capture=false
        @castling=""
        @spec=""
        raise BadMoveError if parser(actual_move)=="bad"
        raise ErrMoveError if (@@status=legal_move)==""
    end

    # Here follows class method for obtain status of the game: 
    
    # actual_turn return actual turn of the game, that start at 1
    def self.actual_turn
        return @@game_history.size/2 + 1
    end

    # white_move? return if actual move is for white (true) of for black (false)
    def self.white_move?
        @@game_history.size.even? 
    end

    # move_stack return the array of the moves
    def self.move_stack
        return @@game_history.map {|h| h.keys}
    end

    # position return actual position
    def self.position
        return @@position
    end

    def self.start_position=(pos)
        @@position=pos
    end

    # last_move return last move
    def self.last_move
        return @@game_hystory[-1].keys
    end

    # game_status return the status of the game
    def self.status
        return @@status
    end

    def self.status=(s)
        @@status=s
    end

    def reset!
        @@position={}
        @@game_history=[]
        @@status="game"
    end



    # method parser (perhaps private) examine the move, and separe the target square, the Piece that have to do the move
    # and eventual other elements: capture flag, promotion piece, a specify element for resolve move conflicts, 
    # and a special container for long and short castling.
    # parser return an error message "The Move is not Recognized" if the parsing is not correct or if the move is outside the board.

    def parser(actual_move)
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
        mv=@actual_move.split("")
        mv.pop if mv[-1].match?(/[\+\#]/)

        case mv 
            in ["r","e","s","i","g","n"] 
                Move.status="end_resign"
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
            in [spec,"x",col,row] if spec.match?(/[a-h]|[1-8]/)
                piece_sym="P"
                @capture=true
            in [piece_sym, spec,col,row] if (spec.match?(/[a-h]|[1-8]/) && CHESS_DICTIONARY.keys.include?(piece_sym))
                @capture=false
            in [piece_sym, spec,"x",col,row] if (spec.match?(/[a-h]|[1-8]/) && CHESS_DICTIONARY.keys.include?(piece_sym))
                @capture=true
            in [col,row,"=",promote] if CHESS_DICTIONARY.keys.include?(promote)
                piece_sym="P"
                @capture=false
            in [spec,"x",col,row,"=",promote] if (spec.match?(/[a-h]|[1-8]/) && CHESS_DICTIONARY.keys.include?(promote))
                piece_sym="P"
                @capture=true
            else 
            return "bad"
        end       
        @coordinates=[col,row]
        @piece_sym=piece_sym
        @spec=spec
        @promote=promote
    end

    # legal_move find the piece that can do the move and test if the move is possible
    # if the move is not possible, it return "" that raise an ErrMoveError
    # if it is possible, it will generate a status that can be "game", normally, or one of end_game flags
    def legal_move
        candidates=@@position.find {|coord,piece| piece==CHESS_DICTIONARY[@piece_sym] &&
                                    piece.legal_move(self,coord)}
        case candidates.size
        when 0
            return ""
        when 1
            candidate=candidates[0]
        else
            case @spec
            when /[1-8]/
                candidate=candidates.first {|coord,_| coord[1]==@spec}
            when /[a-h]/
                candidate=candidates.first {|coord,_| coord[0]==@spec}
            else
                return ""
            end
        end
        
        make_move(candidate)
    end





end
        
    










