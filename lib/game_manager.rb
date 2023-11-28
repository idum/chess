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
            move=""
            loop do
                err=""
                move=@game.take_move(move_stack.size,err)
                err=eval_move(move,position)
                break if err==""
            end
            status=make_move(move,move_stack)
        end
    end

    def eval_move(move, position)
        return ""
    end

    def make_move(move, move_stack)
        return "end_mate"
    end


end        

a=GameManager.new
a.new_game
