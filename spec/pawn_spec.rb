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
    context "standard moves" do
        before do
            @pawn=Pawn.new(color: "W")
            @bpawn=Pawn.new(color: "B")
            Game.position={
                ["e","2"] => @pawn,
                ["e","7"] => @bpawn,
                ["h","4"] => @pawn,
                ["a","5"] => @bpawn
            }
        end
        it "should do a 1-square move" do
            expect(@pawn.legal_move(["e","3"],["e","2"])).to be true
            expect(@bpawn.legal_move(["e","6"],["e","7"])).to be true
        end

        it "should do a 2-square move while in starting square" do
            expect(@pawn.legal_move(["e","4"],["e","2"])).to be true
            expect(@bpawn.legal_move(["e","5"],["e","7"])).to be true
        end

        it "shouldn't do a back move" do
            expect(@pawn.legal_move(["h","3"],["h","4"])).to be false
            expect(@bpawn.legal_move(["a","6"],["a","5"])).to be false
        end

        it "shouldn't do a diagonal move" do
            expect(@pawn.legal_move(["f","5"],["h","4"])).to be false
            expect(@bpawn.legal_move(["b","4"],["a","5"])).to be false
        end

        it "shouldn't do a 2-square move while not in starting square" do
            expect(@pawn.legal_move(["h","6"],["h","4"])).to be false
            expect(@bpawn.legal_move(["a","3"],["a","5"])).to be false
        end

        it "shouldn't do a 3-square move while in starting square" do
            expect(@pawn.legal_move(["e","5"],["e","2"])).to be false
            expect(@bpawn.legal_move(["e","4"],["e","7"])).to be false
        end

        it "shouldn't do a 1-square move with not free road" do
            Game.position={
                ["a","3"] => Piece.new,
                ["a","6"] => Piece.new,
                ["a","2"] => @pawn,
                ["a","7"] => @bpawn
                }
            expect(@pawn.legal_move(["a","3"],["a","2"])).to be false
            expect(@bpawn.legal_move(["a","6"],["a","7"])).to be false
        end

        it "shouldn't do a 2-square move with not free road" do
            Game.position={
                ["a","3"] => Piece.new,
                ["a","6"] => Piece.new,
                ["a","2"] => @pawn,
                ["a","7"] => @bpawn
                }
            expect(@pawn.legal_move(["a","4"],["a","2"])).to be false
            expect(@bpawn.legal_move(["a","5"],["a","7"])).to be false
        end
    end

    context "standard capture moves" do
        before do
            @pawn=Pawn.new(color: "W")
            @bpawn=Pawn.new(color: "B")
            Game.position={
                ["b","4"] => @pawn,
                ["c","5"] => Piece.new(color:"B"),
                ["a","5"] => Piece.new(color:"B"),
                ["b","5"] => Piece.new(color:"B"),
                ["f","5"] => @bpawn,
                ["e","4"] => Piece.new(color:"W"),
                ["g","4"] => Piece.new(color:"W"),
                ["f","4"] => Piece.new(color:"W")                
            }
        end
        
        it "should capture with regular move W " do
            expect(@pawn.legal_move(["a","5"],["b","4"],capture: true)).to be true
            expect(@pawn.legal_move(["c","5"],["b","4"],capture: true)).to be true
        end

        it "should capture with regular move B " do
            expect(@bpawn.legal_move(["e","4"],["f","5"],capture: true)).to be true
            expect(@bpawn.legal_move(["g","4"],["f","5"],capture: true)).to be true
        end

        it "shouldn't capture a pawn on the same column" do
            expect(@bpawn.legal_move(["f","4"],["f","5"],capture: true)).to be false
            expect(@pawn.legal_move(["b","5"],["b","4"],capture: true)).to be false
        end

        it "shouldn't capture a friend piece" do
            Game.position[["g","4"]]=Piece.new(color:"B")
            Game.position[["a","5"]]=Piece.new(color:"W")
            expect(@bpawn.legal_move(["g","4"],["f","5"],capture: true)).to be false
            expect(@pawn.legal_move(["a","5"],["b","4"],capture: true)).to be false
        end

        it "shouldn't capture where there is no enemy pieces" do
            Game.position.delete(["g","4"])
            Game.position.delete(["a","5"])
            expect(@bpawn.legal_move(["g","4"],["f","5"],capture: true)).to be false
            expect(@pawn.legal_move(["a","5"],["b","4"],capture: true)).to be false
        end

    end
    context "en-passant" do
        before do
            @pawn=Pawn.new(color: "W")
            @bpawn=Pawn.new(color: "B")
        end

        it "should capture with en-passant W " do
            Game.position={
                ["b","5"] => @pawn,
                ["c","5"] => Pawn.new(color:"B",status: "-1"),
                ["a","5"] => Pawn.new(color:"B",status: "-1"),
            }
            expect(@pawn.legal_move(["c","6"],["b","5"],capture: true)).to be true
            expect(@pawn.legal_move(["a","6"],["b","5"],capture: true)).to be true
        end

        it "should capture with en-passant B" do
            Game.position={
                ["g","4"] => @bpawn,
                ["f","4"] => Pawn.new(color:"W",status: "0"),
                ["h","4"] => Pawn.new(color:"W",status: "0"),
            }
            expect(@bpawn.legal_move(["f","3"],["g","4"],capture: true)).to be true
            expect(@bpawn.legal_move(["h","3"],["e","4"],capture: true)).to be true
        end

        it "shouldn't capture with en-passant not pawn pieces" do
            Game.position={
                ["b","5"] => @pawn,
                ["c","5"] => Piece.new(color:"B",status: "-1"),
                ["g","4"] => @bpawn,
                ["f","4"] => Piece.new(color:"W",status: "0"),
            }
            expect(@pawn.legal_move(["c","6"],["b","5"],capture: true)).to be false
            expect(@bpawn.legal_move(["f","3"],["g","4"],capture: true)).to be false
        end      

        it "shouldn't capture with en-passant pawns with wrong status" do
            Game.position={
                ["b","5"] => @pawn,
                ["c","5"] => Piece.new(color:"B",status: "2"),
                ["g","4"] => @bpawn,
                ["f","4"] => Piece.new(color:"W",status: "1"),
            }
            expect(@pawn.legal_move(["c","6"],["b","5"],capture: true)).to be false
            expect(@bpawn.legal_move(["f","3"],["g","4"],capture: true)).to be false
        end

        it "shouldn't capture with en-passant friendly pieces" do
            Game.position={
                ["b","5"] => @pawn,
                ["c","5"] => Piece.new(color:"W",status: "-1"),
                ["g","4"] => @bpawn,
                ["f","4"] => Piece.new(color:"B",status: "0"),
            }
            expect(@pawn.legal_move(["c","6"],["b","5"],capture: true)).to be false
            expect(@bpawn.legal_move(["f","3"],["g","4"],capture: true)).to be false
        end
    end

    context "promotion move" do
        before do
            @pawn=Pawn.new(color: "W")
            @bpawn=Pawn.new(color: "B")
            Game.position={
                ["b","7"] => @pawn,
                ["c","8"] => Piece.new(color: "B"),
                ["a","8"] => Piece.new(color: "B"),
                ["c","2"] => @bpawn,
                ["b","1"] => Piece.new(color: "B"),
                ["d","1"] => Piece.new(color: "B")
            }
        end
        after do
            Game.reset!
        end

        it "should promote with and without capture W" do
            expect(@pawn.legal_move(["b","8"],["b","7"],promotion_piece: "Q")).to be true
            expect(@pawn.legal_move(["c","8"],["b","7"],promotion_piece: "R", capture: true)).to be true
            expect(@pawn.legal_move(["a","8"],["b","7"],promotion_piece: "R", capture: true)).to be true
        end

        it "should promote with and without capture B" do
            expect(@bpawn.legal_move(["c","1"],["c","2"],promotion_piece: "Q")).to be true
            expect(@bpawn.legal_move(["b","1"],["c","2"],promotion_piece: "R", capture: true)).to be true
            expect(@bpawn.legal_move(["d","1"],["c","2"],promotion_piece: "R", capture: true)).to be true
        end

        it "shouldn't promote in pawn, king or not existent pieces" do
            expect(@bpawn.legal_move(["c","1"],["c","2"],promotion_piece: "P")).to be false
            expect(@bpawn.legal_move(["b","1"],["c","2"],promotion_piece: "K", capture: true)).to be false
            expect(@bpawn.legal_move(["d","1"],["c","2"],promotion_piece: "H", capture: true)).to be false
        end 

        it "shouldn't promote if not in 2nd row for white or 7th row for black" do
            Game.position[["g","6"]] = @pawn
            Game.position[["f","5"]] = @bpawn
            expect(@pawn.legal_move(["g","7"],["g","6"],promotion_piece: "P")).to be false
            expect(@bpawn.legal_move(["f","4"],["f","5"],promotion_piece: "P")).to be false
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
end

    