# space is a particular type of Piece that rapresent the empty space
# it cannot be moved and his avatar is the empty or full space (eventually colored)
class Space < Piece
    WHITESPACECOLOR="Cornsilk"
    BLACKSPACECOLOR="Cyan"  
    def initialize (color, position="out", status="start")
        @avatar=WHITESPACE
        set_color(color)
        @position = position
        @status = status
    end
end