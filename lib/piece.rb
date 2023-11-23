# Class Piece is the ancestor class for all the pieces of chess.
# It define basic elements: 
# color, piece game side, that can be "B" = black or "W" = white
# status, that check if the piece is in game or not, and can be "init", initial position 
#   on the board, "ingame" if the piece is on the board during a game, "capt" if the piece is captured and out of the board
# position, that define position on the board, and can be "out", if captured
#


class Piece
    attr_reader :color, :position, :status

    def initialize(color="W",position="out",status="init")
        @color="W"
        @position="out"
        @status="init"
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

    private

    def test_position(c)
        return true if c=="out"
        return false if c.size!=2
        col,row = c.chars
        return (col.match?(/[a-h]/) && row.match?(/[1-8]/)) 
    end

end