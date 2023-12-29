#2nd refactor
# Game Class is the game container (precedently all was in move). 
# here we will find all the utilities for examine the flux of the game: the position, the turn, the game history, etc.
# it also invoke the right move sequence: parser, find_piece( precedently legal_move), move_piece, and talk with 
# game_manager for the error messages
require_relative "move"
class Game

    class << self
        attr_accessor :history, :position, :status, :error
    end

    @position={}
    @history=[]
    @status="game"
    @error=""

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
        @error=""
    end

    def self.save_move(move)
        h={move => @position.clone}
        @history.push(h)
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

    def self.repetition_draw
        a={}
        @history.each do |turn|
            position=turn.values[0]
            a[position] ? a[position]+=1 : a[position]=1
            return true if a[position]==3
        end
        return false
    end

    def self.threatened_square(square,color=self.who_move)
        old_position=Game.position.clone
        Game.position[square]=Piece.new(color: color)       
        a=Game.position.any? {|pos,piece|
            piece.legal_move(square,pos,capture: true)
        }
        Game.position=old_position
        return a        
    end

    def self.check_condition(color=self.who_move)
        king=Game.position.select {|pos,piece|
            piece.class==King &&
            piece.color==color        
        }
        return false if king=={}
        self.threatened_square(king.keys[0])
    end
end


