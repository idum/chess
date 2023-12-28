# Class GameManager is the base class of the app. It manage all the game, from creating the board to read the moves
# execute the move and control end game conditions
# It is a sort of gateway for the I/O interface selected. In this first cycle of develop we consider only console I/O
# Game manager also open option for load saved games or pre-built positions, in next devcycs


require_relative "console_board"
require_relative "move"
require_relative "game"


class GameManager
    attr_reader :media, :variant, :this_match
   
    def initialize(variant="classic",media="console")
        Game.reset!
        @variant = variant
        case media
        when "console"
            @this_match=ConsoleBoard.new(variant,media)
        end
    end

    def new_game
        @this_match.show_game
        loop do
            break if Game.error=="endgame"   
            @this_match.take_move
            @this_match.show_game     
        end
    end

    def load_game
        false
    end

    def load_position
        false
    end

end        

a=GameManager.new
a.new_game
