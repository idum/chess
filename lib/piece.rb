# Class Piece is the interface class for all the pieces of chess.
# It define basic elements: 
# color, piece game side, that can be "B" = black or "W" = white
# status, that check if the piece is in game or not, and can be 
# "start", initial and "not yet moved" status, "ingame" during a game (moved), "capt" if the piece is captured and out of the board
# position, that define position on the board; 
# avatar: the unicode chess char
# we need this class will be "cleared" from useless elements

require_relative "move"
require_relative "game"
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
    
    attr_accessor :color, :status, :avatar, :coordinates, :piecesym
    
    def initialize(params={})
        @avatar=params.fetch(:avatar, "")
        @color=params.fetch(:color,"")
        @status=params.fetch(:status,"")
        @coordinates=params.fetch(:coordinates,[])
        @piecesym="0"

    end

    def to_s 
        @avatar
    end

    
    # in this part we will define interface models for pieces. 
    # first is the test for legal movement in a generic way
    
    # legal_move will test if the piece that is/should be in piece_coord starting position can move in the target move
    # it accept 2 variables: 
    #   move that is the actual move we will test
    #   piece_coord that is the (hypotetical or real) start position
    

    def legal_move(square_to,square_from,params={})
       
        # The move is not legal if target move is the same of start position or if the target location is occupied to a piece with same color
        # Those are general rules. Each piece have eventual exceptions, so each piece have their legal_move implementation.     
        return false if self.class==Piece
        
    end

    def try_move(square_to,square_from,test=true)
        old_position=Game.position
        Game.position.delete(square_from)
        Game.position[square_to]=self
        if Game.check_condition(self.color)
            Game.position=old_position
            return false
        end
        Game.position=old_position if test
        true
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

    def mv_distance(a,b)
        return a.ord - b.ord
    end

      

end

