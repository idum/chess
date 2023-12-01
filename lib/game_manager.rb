# Class GameManager is the base class of the app. It manage all the game, from creating the board to read the moves
# execute the move and control end game conditions
# In this first develop cycle, we accept input from stdin as string; the move will be checked and executed
# and the output will be the board (as sequence of strings) and the eventual end-game condition
# We will provide a log command for recall all the moves.
# In eventual following develop cycles we will try to implement html page with graphical improvements.


require_relative "chess_board"
require_relative "move"


class GameManager
    attr_reader :media, :variant, :game
   
    def initialize(variant="classic",media="console")
        @variant = variant
        @media = media
    end

    def new_game
        @game=ChessBoard.new(@variant,@media)
        Move.reset!
        letsplay
    end

    def letsplay
        loop do
            move_stack=Move.move_stack
            @game.show_game 
            return if Move.status!="game"
            move=@game.take_move
            
        end
    end

    

end        

a=GameManager.new
a.new_game
