# Class Piece is the interface class for all the pieces of chess.
# It define basic elements: 
# color, piece game side, that can be "B" = black or "W" = white
# status, that check if the piece is in game or not, and can be 
# "start", initial and "not yet moved" status, "ingame" during a game (moved), "capt" if the piece is captured and out of the board
# position, that define position on the board, and can be "out", if captured or in setup phase
# avatar: the unicode chess char


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
    
    

    attr_reader :color, :position, :status, :avatar
 
    def initialize
        @color="W"
        @position="out"
        @status="init"
        @avatar=""
    end

    def set_color(c)
        return false if !c.match?(/^[WB]{1}$/)
        @color=c
        return true
    end

    def set_status(c)
        return false if !(["start","ingame","capt"].include? c)
        @status=c
        return true
    end

    def set_position(c)
        return false if !test_position(c)
        @position=c
        return true
    end

    #forse non va bene
    def set_avatar(c)
        return false if !c.match?(/[\u2654-\u265F]/)
        @avatar=c
        return true
    end

    def to_s 
        @avatar
    end

    # in this part we will define interface models for pieces. 
    # first is the test for legal movement in a generic way
    # a move is correct if a) respect test_position b) respect piece_movement

    def legal_move(move,*board)
        return test_position(move) && piece_movement(move)
    end

    def piece_movement(move)
        true
    end

    private

    def test_position(c)
        return true if c=="out"
        return false if c.size!=2
        col,row = c.chars
        return (col.match?(/[a-h]/) && row.match?(/[1-8]/)) 
    end

end

