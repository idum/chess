# Class GameManager is the base class of the app. It manage all the game, from creating the board to read the moves
# execute the move and control end game conditions
# In this first develop cycle, we accept input from stdin as string; the move will be checked and executed
# and the output will be the board (as sequence of strings) and the eventual end-game condition
# We will provide a log command for recall all the moves.
# In eventual following develop cycles we will try to implement html page with graphical improvements.

require_relative "king"
require_relative "bishop"
require_relative "rook"
require_relative "knight"
require_relative "queen"
require_relative "pawn"
require_relative "space"
require_relative "chess_board"

class GameManager
   
    def initialize(variant="classic")
        @variant=variant
        @game=Hash.new{}
        @move_stack=Array.new
    end

    def new_game
        @board=ChessBoard.new(@variant)
        @game=@board.setup_board
        # prova @move_stack=["e4","e5","Cc3","Cc6","Ab7","Troi","asf","wss","ffds","sd","O-O","O-O-O","kds"]
        @board.putconsole(@game,@move_stack)
        #gestione mosse
    end

    

end        

a=GameManager.new
puts a.new_game
