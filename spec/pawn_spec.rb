require "./lib/game"

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
        @pawn=Pawn.new(color: "W", coordinates: ["e","2"], status: "0")
        @bpawn=Pawn.new(color: "B", coordinates: ["e","7"])
        Game.position={["b","5"] => Pawn.new(color: "B", status: "0"), 
           ["f","4"] => Pawn.new(color: "W", status: "1"), 
           ["b","1"] => Pawn.new(color: "W", status: "0"),
           ["c","8"] => Pawn.new(color: "B", status: "0"),
           ["a","5"] => Pawn.new(color: "B", status: "-1"),
           ["h","4"] => Pawn.new(color: "W", status: "2"),
           ["d","5"] => Piece.new(color: "B", status: "0"),
           ["d","4"] => Piece.new(color: "W", status: "1"),
           ["e","2"] => @pawn,
           ["e","7"]=> @bpawn
        }     
    end

    after (:all) do
        Game.reset!
    end

    context "correct moves" do
        it "should do a 1-square move W" do
            expect(@pawn.legal_move(["e","5"],["e","4"])).to be true
        end
        
        it "should do a 1-square move B" do
            expect(@bpawn.legal_move(["e","6"],["e","7"])).to be true
        end

        it "should do a 2-square move W" do
            expect(@pawn.legal_move(["e","4"],["e","2"])).to be true
        end
        it "should do a 2-square move B" do
            expect(@bpawn.legal_move(["e","5"],["e","7"])).to be true
        end

        it "should capture with regular move W right" do
            expect(@pawn.legal_move(["b","5"],["a","4"],capture: true)).to be true
        end
        it "should capture with regular move W left" do
            expect(@pawn.legal_move(["b","5"],["c","4"],capture: true)).to be true
        end
        it "should capture with regular move B left" do
            expect(@bpawn.legal_move(["f","4"],["g","5"],capture: true)).to be true
        end
        it "should capture with regular move B right" do
            expect(@bpawn.legal_move(["f","4"],["e","5"],capture: true)).to be true
        end

        it "should capture with en-passant W right" do
            expect(@pawn.legal_move(["b","6"],["a","5"],capture: true)).to be true
        end
        it "should capture with en-passant W left" do
            expect(@pawn.legal_move(["b","6"],["c","5"],capture: true)).to be true
        end
        it "should capture with en-passant B left" do
            expect(@bpawn.legal_move(["f","3"],["g","4"],capture: true)).to be true
        end
        it "should capture with en-passant B right" do
            expect(@bpawn.legal_move(["f","3"],["e","4"],capture: true)).to be true
        end

        it "should promote without capture W" do
            expect(@pawn.legal_move(["b","8"],["b","7"],promotion_piece: "Q")).to be true
        end
        it "should promote with capture W left" do
            expect(@pawn.legal_move(["c","8"],["d","7"],promotion_piece: "R", capture: true)).to be true
        end
        it "should promote with capture W right" do
            expect(@pawn.legal_move(["c","8"],["b","7"],promotion_piece: "R", capture: true)).to be true
        end
        it "should promote without capture B" do
            expect(@bpawn.legal_move(["c","1"],["c","2"],promotion_piece: "Q")).to be true
        end
        it "should promote with capture B left" do
            expect(@bpawn.legal_move(["b","1"],["c","2"],promotion_piece: "R", capture: true)).to be true
        end
        it "should promote with capture B right" do
            expect(@bpawn.legal_move(["b","1"],["a","2"],promotion_piece: "R", capture: true)).to be true
        end
    end

    context "wrong moves" do
        it "try to move in the same square" do
            expect(@pawn.legal_move(["h","7"],["h","7"])).to be false
        end
        it "try to move to 3 squares W" do
            expect(@pawn.legal_move(["e","5"],["e","2"])).to be false
        end
        it "try to move to 3 squares B" do
            expect(@bpawn.legal_move(["e","4"],["e","7"])).to be false
        end
        it "try to move with 1-square move where there is a piece with same color W" do
            expect(@pawn.legal_move(["f","4"],["f","3"])).to be false
        end
        it "try to move with 1-square move where there is a piece with same color W" do
            expect(@bpawn.legal_move(["b","4"],["b","3"])).to be false
        end
        it "try to move with 2-square move where there is a enemy piece W" do
            expect(@pawn.legal_move(["f","4"],["f","2"])).to be false
        end
        it "try to move with 2-square move where there is a enemy piece B" do
            expect(@bpawn.legal_move(["f","5"],["b","7"])).to be false
        end

        it "try to capture with a not diagonal 1-square move W" do
            expect(@pawn.legal_move(["b","4"],["b","3"],capture: true)).to be false
        end
        it "try to capture with a not diagonal 1-square move B" do
            expect(@bpawn.legal_move(["f","5"],["f","4"],capture: true)).to be false
        end
        it "try to promote when pawn is in row 6 W" do
            expect(@pawn.legal_move(["c","8"],["c","6"],promotion_piece: "Q")).to be false
        end
        it "try to promote when pawn is in row 3 B" do
            expect(@bpawn.legal_move(["c","1"],["c","3"],promotion_piece: "Q")).to be false
        end
        it "try to move in row 8 without promotion flag W" do
            expect(@pawn.legal_move(["c","8"],["c","7"])).to be false
        end
        it "try to move in row 1 without promotion flag B" do
            expect(@bpawn.legal_move(["c","1"],["c","2"])).to be false
        end
        it "try to capture diagonally without flag capture W" do
            expect(@pawn.legal_move(["b","4"],["c","3"])).to be false
        end
        it "try to capture diagonally without flag capture B" do
            expect(@bpawn.legal_move(["f","5"],["e","4"])).to be false
        end
        it "try to capture en-passant a not-pawn piece W" do
            expect(@pawn.legal_move(["d","6"],["c","5"], capture: true)).to be false
        end
        it "try to capture en-passant a not-pawn piece B" do
            expect(@bpawn.legal_move(["d","3"],["c","4"], capture: true)).to be false
        end
        it "try to capture en-passant a B pawn that has not made 2-square move in last turn (status.to_i != (actual_status -1)" do
            expect(@pawn.legal_move(["a","6"],["b","5"])).to be false
        end
        it "try to capture en-passant a W pawn that has not made 2-square move in last turn (status.to_i != (actual_status -1)" do
            expect(@bpawn.legal_move(["h","6"],["g","5"])).to be false
        end
        it "try to capture an empty square W" do
            expect(@pawn.legal_move(["b","7"],["c","6"], capture: true)).to be false
        end
        it "try to capture an empty square B" do
            expect(@bpawn.legal_move(["b","6"],["c","7"], capture: true)).to be false
        end

        it "try to move with 2-square move with a piece in front of the pawn" do
            Game.position={["a","3"] => Piece.new,
                 ["a","6"] => Piece.new,
                 ["a","2"] => @pawn,
                 ["a","7"] => @bpawn
                }
            expect(@pawn.legal_move(["a","4"],["a","2"])).to be false
            expect(@bpawn.legal_move(["a","5"],["a","7"])).to be false
        end
        
    end 
end
  
context "try_move and can_move_there?" do
    before do
        @pawn=Pawn.new(color: "W",  status: "0")
        @bpawn=Pawn.new(color: "B")
        Game.position={
            ["e","2"] => @pawn,
            ["e","7"] => @bpawn
        }
    end
    
    it "it should be possible because king is not present,test if status is not adjourned(test mode)" do
        expect(@pawn.can_move_there?(["e","4"],["e","2"])).to be true
        expect(@pawn.legal_move(["e","4"],["e","2"])).to be true
        expect(@pawn.try_move(["e","4"],["e","2"])).to be true
        expect(@pawn.status).to eql("0")

    end
    it "it should be possible because king is not threatened" do
        Game.position[["a","8"]]=King.new(color: "W")
        expect(@pawn.can_move_there?(["e","4"],["e","2"])).to be true
        expect(@pawn.legal_move(["e","4"],["e","2"])).to be true
        expect(@pawn.try_move(["e","4"],["e","2"])).to be true
        Game.position.delete(["a","8"])
    end
    it "it should not be possible because king is threatened" do
        Game.position[["d","6"]]=King.new(color: "W")
        expect(@pawn.can_move_there?(["e","4"],["e","2"])).to be false
        expect(@pawn.legal_move(["e","4"],["e","2"])).to be true
        expect(Game.check_condition(@pawn.color)).to be true
        expect(@pawn.try_move(["e","4"],["e","2"])).to be false
    end
    it "now pawn is in f6 and can capture e7, removing the threat" do
        Game.position[["d","6"]]=King.new(color: "W")
        Game.position[["f","6"]]=@pawn
        expect(@pawn.can_move_there?(["e","7"],["f","6"])).to be true
        expect(@pawn.legal_move(["e","7"],["f","6"], capture: true)).to be true
        expect(Game.check_condition(@pawn.color)).to be true
        expect(@pawn.try_move(["e","7"],["f","6"])).to be true
    end
    it "same move, with test flag = false, verify that the move if effectively done" do
        Game.position[["d","6"]]=King.new(color: "W")
        Game.position[["f","6"]]=@pawn
        expect(@pawn.try_move(["e","7"],["f","6"],test=false)).to be true
        expect(Game.position[["f","6"]]).to be nil
        expect(Game.position[["e","7"]]).to eql(@pawn)
    end
    it "test en_passant" do
        Game.position[["b","5"]]=Pawn.new(color: "B", status: "-1")
        Game.position[["c","5"]]=@pawn
        expect(@pawn.legal_move(["b","6"],["c","5"], capture: true)).to be true
        expect(@pawn.try_move(["b","6"],["c","5"], test=false)).to be true
        expect(Game.position[["b","5"]]).to be nil
        expect(Game.position[["b","6"]]).to eql(@pawn)
    end
    it "test promotion" do
        Game.position[["b","7"]]=@pawn
        expect(@pawn.try_move(["b","8"],["b","7"], test=false, promotion_piece: "Q")).to be true
        expect(Game.position[["b","8"]].class).to eql(Queen)
    end

end

    