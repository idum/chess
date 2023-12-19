#2nd refactor
# Game Class is the game container (precedently all was in move). 
# here we will find all the utilities for examine the flux of the game: the position, the turn, the game history, etc.
# it also invoke the right move sequence: parser, find_piece( precedently legal_move), move_piece, and talk with 
# game_manager for the error messages
require_relative "move"
class Game

    class << self
        attr_accessor :history, :position, :status
    end

    @position={}
    @history=[]
    @status="game"

    def self.actual_turn
        (@history.size/2) + 1
    end

    def self.who_move
        (@history.size%2)==0 ? "W" : "B"
    end

    def self.move_stack
        return @history.map {|h| h.keys}.flatten
    end

    def self.last_move
        @history[-1].keys[0]
    end

    def self.reset!
        @position={}
        @history=[]
        @status="game"
    end

    def self.turn_back
        @history.pop
        @position=@history[-1].values[0]
    end

    def self.goto_turn(turn,color)
        color=="W"? a=(turn-1)*2 : a=(turn-1)*2+1
        @history=@history[0...a]
        @position = history[-1].values[0]
    end

    def self.load_game(history)
        @history = history
        @position = history[-1].values[0]
    end

    def history=(history)
        self.load_game(history)
    end
end


