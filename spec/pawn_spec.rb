require "./lib/move"
require "./lib/pawn"

# class Pawn define the movement rules for any pawn
# it is probably the most complicate piece to define as model, due the many special rules 
# in test, we werify that, for white and black, all movement rules are well defined
# this will be checked by legal_move method. Scope of this method is to verify if a Pawn that is in a defined position can do a given move.
# It require 2 variables: 
#  move (class Move), that is the move Pawn should do
#  piece_coord, in the form [row(/[a-h]/),col(/[1-8]/)] that is the actual position of the pawn we are analyzing 
# It return true if the pawn can do the move


describe Pawn do
    before(:all) do
        @pawn=Pawn.new(color="W")
        b={["b","4"] => Pawn.new(color="B"), ["f","5"] => Pawn.new(color="W")}
        Move.start_position(b)
    end


end