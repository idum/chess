require "./lib/game"

#Class Rook define rules for Rook movement. A Rock can move ortogonally to its position, 
# so along the row or the col from his starting position.
# Rook cannot jump over other pieces, but it can capture, in a move capture a target enemy piece
# if the line from the rook and the piece is free to run

describe "Rook" do
    before(:all) do
        @rook=Rook.new(color: "W")
        Game.position={["b","4"] => Piece.new(color: "B"),
           ["f","4"] => @rook,
           ["f","6"] => Rook.new(color: "B"),
           ["f","7"] => Rook.new(color: "B"),
        }
        
    end
    after(:all) do
        Game.reset!
    end
    context "base test" do
        it "should fail to move in starting square" do
            expect(@rook.legal_move(["f","4"],["f","4"])).to be false
        end
        it "should fail to move in an square occupied to friend piece" do
            expect(@rook.legal_move(["f","7"],["g","7"])).to be false
        end
        it "should fail to move in a square occupied to enemy piece if move is not a capture" do
            expect(@rook.legal_move(["f","6"],["g","6"])).to be false
        end
        it "should fail if movement is not orthogonal" do
            expect(@rook.legal_move(["f","6"],["g","5"])).to be false
        end
    end

    context "correct move" do
        it "should move along a free col " do
            expect(@rook.legal_move(["f","1"],["f","4"])).to be true
        end
        it "should move along a free row" do
            expect(@rook.legal_move(["h","4"],["f","4"])).to be true
        end
        it "shold capture a piece along a col" do
            expect(@rook.legal_move(["f","6"],["f","4"], capture: true)).to be true
        end
        it "shold capture a piece along a row" do
            expect(@rook.legal_move(["b","4"],["f","4"], capture: true)).to be true
        end
    end
    context "bad moves" do
        it "should fail to move along a not free row" do
            expect(@rook.legal_move(["a","4"],["f","4"])).to be false
        end
        it "should fail to move along a not free col" do
            expect(@rook.legal_move(["f","8"],["f","4"])).to be false
        end   
        it "shold fail to capture a piece if the road is not free" do
            expect(@rook.legal_move(["f","7"],["f","4"], capture: true)).to be false
        end
    end
    context "try_move" do
        it "it should be possible because king is not present" do
            expect(@rook.legal_move(["f","1"],["f","4"])).to be true
            expect(@rook.try_move(["f","1"],["f","4"])).to be true
        end
        it "it should be possible because king in e1 is not threatened" do
            Game.position[["e","1"]]=King.new(color: "W")
            expect(@rook.legal_move(["f","1"],["f","4"])).to be true
            expect(Game.check_condition(@rook.color)).to be false
            expect(@rook.try_move(["f","1"],["f","4"])).to be true
            Game.position.delete(["e","1"])
        end
        it "it should not be possible because king in f6 is threatened" do
            Game.position[["e","6"]]=King.new(color: "W")
            expect(@rook.legal_move(["f","1"],["f","4"])).to be true
            expect(Game.check_condition(@rook.color)).to be true
            expect(@rook.try_move(["f","1"],["f","4"])).to be false
        end
        it "now @rook will can capture enemy rook in f6 (and defend king from enemy rook in f7) and remove the threat" do
            expect(@rook.legal_move(["f","6"],["f","4"], capture: true)).to be true
            expect(Game.check_condition(@rook.color)).to be true
            expect(@rook.try_move(["f","6"],["f","4"])).to be true
        end
        it "same move, with test flag = false, verify that the move if effectively done" do
            expect(@rook.try_move(["f","6"],["f","4"],test=false)).to be true
            expect(Game.position[["f","4"]]).to be nil
            expect(Game.position[["f","6"]]).to eql(@rook)
        end
    end
end