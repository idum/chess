# Class Piece is the interface class for all the pieces of chess.
# It define basic elements: 
# color, piece game side, that can be "B" = black or "W" = white
# status, that check if the piece is in game or not, and can be 
# "start", initial and "not yet moved" status, "ingame" during a game (moved), "capt" if the piece is captured and out of the board
# position, that define position on the board; 
# avatar: the unicode chess char
# we need this class will be "cleared" from useless elements


class Piece
    #unicode values for pieces"

    WHITEKING = "\u2654"
    WHITEQUEEN = "\u2655"
    WHITEROOK = "\u2656"
    WHITEBISHOP = "\u2657"
    WHITEKNIGHT = "\u2658"
    WHITEPAWN = "\u2659"
    
    BLACKKING = "\u265A"
    BLACKQUEEN = "\u265B"
    BLACKROOK = "\u265C"
    BLACKBISHOP = "\u265D"
    BLACKKNIGHT = "\u265E"
    BLACKPAWN = "\u265F"
    
    attr_reader :color, :status, :avatar
    
    def initialize
        @avatar=""
        @color=""
        @status=""
    end

    def to_s 
        @avatar
    end

    def set_color(color)
        @color=color
        
    end

    # in this part we will define interface models for pieces. 
    # first is the test for legal movement in a generic way
    # a move is correct if a) respect test_position b) respect piece_movement

    def legal_move(start_location, move, position,distinguish_mark,captured,promotion,turn)
        # The move is not legal if target move is the same of start position or if the target location is occupied to a piece with same color
        if (distinguish_mark.nil? ||!distinguish_mark.match?(/o-o/)) 
            return false if move==start_location
            return false if position[move] && position[move].color==position[start_location].color
            return false if captured && position[move].nil?
        end

        
        #now every piece can add her movement rule
        #return true
    end

    def test_position(c)
        # test if out is a special test that can be useful for future graphical needings
        # return true if c=="out"
        return false if c.size!=2
        col,row = c.chars
        return (col.match?(/[a-h]/) && row.match?(/[1-8]/)) 
    end

    private
    #some methods for modify rows and colums
    def mv_col(c,step)
        r=c.ord + step
        return r.chr if (r<=104 && r>=97)
        return false
    end

    def mv_row(c,step=1)
        r=c.ord + step
        return r.chr if (r<=56 && r>=49)
        return false
    end

      

end

