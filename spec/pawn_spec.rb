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
        @pawn=Pawn.new(color: "W", coordinates: ["e","2"])
        @bpawn=Pawn.new(color: "B", coordinates: ["e","7"])
        b={["b","5"] => Pawn.new(color: "B", status: "0"), 
           ["f","4"] => Pawn.new(color: "W", status: "0"), 
           ["b","1"] => Pawn.new(color: "B", status: "0"),
           ["c","8"] => Pawn.new(color: "W", status: "0"),
           ["a","5"] => Pawn.new(color: "B", status: "-1"),
           ["h","4"] => Pawn.new(color: "W", status: "2"),
           ["d","5"] => Piece.new(color: "B", status: "0"),
           ["d","4"] => Piece.new(color: "W", status: "0"),
           @pawn.coordinates => @pawn,
           @bpawn.coordinates => @bpawn
        }
        Move.start_position=b
    end

    context "correct moves" do
        it "should do a 1-square move W" do
            expect(@pawn.legal_move(Move.new("e5"),["e","4"])).to be true
        end

        it "should do a 1-square move B" do
            expect(@bpawn.legal_move(Move.new("e6"),["e","7"])).to be true
        end

        it "should do a 2-square move W" do
            expect(@pawn.legal_move(Move.new("e4"),["e","2"])).to be true
        end
        it "should do a 2-square move B" do
            expect(@bpawn.legal_move(Move.new("e5"),["e","7"])).to be true
        end

        it "should capture with regular move W right" do
            expect(@pawn.legal_move(Move.new("axb5"),["a","4"])).to be true
        end
        it "should capture with regular move W left" do
            expect(@pawn.legal_move(Move.new("cxb5"),["c","4"])).to be true
        end
        it "should capture with regular move B left" do
            expect(@bpawn.legal_move(Move.new("gxf4"),["g","5"])).to be true
        end
        it "should capture with regular move B right" do
            expect(@bpawn.legal_move(Move.new("exf4"),["e","5"])).to be true
        end

        it "should capture with en-passant W right" do
            expect(@pawn.legal_move(Move.new("axb6"),["a","5"])).to be true
        end
        it "should capture with en-passant W left" do
            expect(@pawn.legal_move(Move.new("cxb6"),["c","5"])).to be true
        end
        it "should capture with en-passant B left" do
            expect(@bpawn.legal_move(Move.new("gxf3"),["g","4"])).to be true
        end
        it "should capture with en-passant B right" do
            expect(@bpawn.legal_move(Move.new("exf3"),["e","4"])).to be true
        end

        it "should promote without capture W" do
            expect(@pawn.legal_move(Move.new("b8=Q"),["b","7"])).to be true
        end
        it "should promote with capture W left" do
            expect(@pawn.legal_move(Move.new("dxc8=R"),["d","7"])).to be true
        end
        it "should promote with capture W right" do
            expect(@pawn.legal_move(Move.new("bxc8=R"),["b","7"])).to be true
        end
        it "should promote without capture B" do
            expect(@bpawn.legal_move(Move.new("c1=Q"),["c","2"])).to be true
        end
        it "should promote with capture B left" do
            expect(@bpawn.legal_move(Move.new("cxb1=B"),["c","2"])).to be true
        end
        it "should promote with capture B right" do
            expect(@bpawn.legal_move(Move.new("axb1=B"),["a","2"])).to be true
        end
    end

    context "wrong moves" do
        it "try to move to 3 squares W" do
            expect(@pawn.legal_move(Move.new("e5"),["e","2"])).to be false
        end
        it "try to move to 3 squares B" do
            expect(@pawn.legal_move(Move.new("e4"),["e","7"])).to be false
        end
        it "try to move with 1-square move where there is a piece with same color W" do
            expect(@pawn.legal_move(Move.new("f4"),["f","3"])).to be false
        end
        it "try to move with 1-square move where there is a piece with same color W" do
            expect(@bpawn.legal_move(Move.new("b4"),["b","3"])).to be false
        end
        it "try to move with 2-square move where there is a enemy piece W" do
            expect(@pawn.legal_move(Move.new("f4"),["f","2"])).to be false
        end
        it "try to move with 2-square move where there is a enemy piece B" do
            expect(@bpawn.legal_move(Move.new("b5"),["b","7"])).to be false
        end
        it "try to capture with a not diagonal 1-square move W" do
            expect(@pawn.legal_move(Move.new("bxb4"),["b","3"])).to be false
        end
        it "try to capture with a not diagonal 1-square move B" do
            expect(@pawn.legal_move(Move.new("fxf5"),["f","4"])).to be false
        end
        it "try to promote in row different to 8 for W (test in move)" do
            expect {@pawn.legal_move(Move.new("c7=Q"),["c","6"])}.to raise_error(BadMoveError)
        end
        it "try to promote in row different to 1 for B (test in move)"do   
            expect {@bpawn.legal_move(Move.new("c2=Q"),["c","3"])}.to raise_error(BadMoveError)
        end
        it "try to promote when pawn is in row 6 W" do
            expect(@pawn.legal_move(Move.new("c8=Q"),["c","6"])).to be false
        end
        it "try to promote when pawn is in row 3 B" do
            expect(@pawn.legal_move(Move.new("c1=Q"),["c","3"])).to be false
        end
        it "try to capture diagonally without flag capture W" do
            expect(@pawn.legal_move(Move.new("b4"),["c","3"])).to be false
        end
        it "try to capture diagonally without flag capture B" do
            expect(@pawn.legal_move(Move.new("f5"),["e","4"])).to be false
        end
        it "try to capture en-passant a not-pawn piece W" do
            expect(@pawn.legal_move(Move.new("cxd6"),["c","5"])).to be false
        end
        it "try to capture en-passant a not-pawn piece B" do
            expect(@bpawn.legal_move(Move.new("cxd3"),["c","4"])).to be false
        end
        it "try to capture en-passant a B pawn that has not made 2-square move in last turn (status.to_i != (actual_status -1)" do
            expect(@pawn.legal_move(Move.new("bxa6"),["b","5"])).to be false
        end
        it "try to capture en-passant a W pawn that has not made 2-square move in last turn (status.to_i != (actual_status -1)" do
            expect(@bpawn.legal_move(Move.new("gxh6"),["g","5"])).to be false
        end
        it "try to capture an empty square W" do
            expect(@pawn.legal_move(Move.new("cxb7"),["c","6"])).to be false
        end
        it "try to capture an empty square B" do
            expect(@bpawn.legal_move(Move.new("cxb6"),["c","7"])).to be false
        end
    end
end