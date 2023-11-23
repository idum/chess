# Class Piece is the ancestor class for all the pieces of chess.
# It define basic elements: 
# color, piece game side, that can be "B" = black or "W" = white
# status, that check if the piece is in game or not, and can be "init", initial position 
#   on the board, "ingame" if the piece is on the board during a game, "capt" if the piece is captured and out of the board
# position, that define position on the board, and can be "out", if captured
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
        return false if !(["init","ingame","capt"].include? c)
        @status=c
        return true
    end

    def set_position(c)
        return false if !test_position(c)
        @position=c
        return true
    end

    def set_avatar(c)
        return false if !c.match?(/[\u2655-\u265F]/)
        @avatar=c
        return true
    end

    def to_s 
        @avatar
    end

    private

    def test_position(c)
        return true if c=="out"
        return false if c.size!=2
        col,row = c.chars
        return (col.match?(/[a-h]/) && row.match?(/[1-8]/)) 
    end

end

