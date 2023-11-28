# Class GameManager is the base class of the app. It manage all the game, from creating the board to read the moves
# execute the move and control end game conditions
# In this first develop cycle, we accept input from stdin as string; the move will be checked and executed
# and the output will be the board (as sequence of strings) and the eventual end-game condition
# We will provide a log command for recall all the moves.
# In eventual following develop cycles we will try to implement html page with graphical improvements.


require_relative "chess_board"

class GameManager
    attr_reader :media, :variant, :game
   
    def initialize(variant="classic",media="console")
        @variant = variant
        @media = media
        @game=ChessBoard.new(variant,media)
    end

    def new_game
        position=@game.start_position
        move_stack=[]
        letsplay(position,move_stack,"game")
    end

    def letsplay(position,move_stack,status)
        loop do
            @game.show_game(position,move_stack,status) 
            return move_stack if status!="game"
            loop do
                move=@game.take_move(move_stack.size,status)
                status=make_move(move,position)
                break if !(status=="bad" || status=="err") 
            end
        end
    end

    def make_move(move, position)
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
        # i) check and checkmate symbols are not accepted in the input, but they will be add in the move_stack record
        mv=move.split("")
        case mv 
            in ["r","e","s","i","g","n"] then return "end_resign"
            in ["o","-","o"] | ["O","-","O"] 
                selected_piece = "K"
                distinguish_mark="o-o"
                col,row="e","4"
                captured=false
            in ["o","-","o","-","o"] | ["O","-","O","-","O"]
                selected_piece = "K"
                distinguish_mark="o-o-o"
                captured=false
            in [selected_piece,col,row]
                captured=false
            in [col,row]
                selected_piece="P"
                captured=false
            in [selected_piece,"x",col,row]
                captured=true
            in [distinguish_mark,"x",col,row]
                selected_piece="P"
                captured=true
            in [selected_piece, distinguish_mark,col,row]
                captured=false
            in [selected_piece, distinguish_mark,"x",col,row]
                captured=false
            in [col,row,"=",promotion]
                selected_piece="P"
            in [distinguish_mark,"x",col,row,"=",promotion]
                selected_piece="P"
        else 
            return "bad"
        end       
        target=col+row    
        # part 2: verify if the move is legal
        # move is legal if it is into the board, and the selected piece can move in the target
        # test will be made by specific movement rules of single pieces
        # problem is to individuate the piece in position that can be the move
        return "bad" if !(col.match?(/[a-h]/) && row.match?(/[1-8]/))
        p "selected_piece = #{selected_piece}, move = #{target}, distinguish_mark = #{distinguish_mark}, promotion=#{promotion}" 
        return "game"        
    end

    


end        

a=GameManager.new
a.new_game
