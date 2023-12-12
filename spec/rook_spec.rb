require "./lib/rook"
require "./lib/move"

#Class Rook define rules for Rook movement. A Rock can move ortogonally to its position, 
# so along the row or the col from his starting position.
# Rook cannot jump over other pieces, but it can capture, in a move capture a target enemy piece
# if the line from the rook and the piece is free to run

describe "Rook" do
    before(:all) do
        @rook=Rook.new(color: "W")
        b={["b","4"] => Piece.new(color: "B"),
           ["f","4"] => @rook,
           ["f","6"] => Rook.new(color: "B"),
           ["f","7"] => Rook.new(color: "B"),
        }
        Move.start_position(b)
    end
    after(:all) do
        Move.reset!
    end
    context "base test" do
        it "should fail to move in starting square" do
            expect(@rook.legal_move(Move.new("Rf4"),["f","4"])).to be false
        end
        it "should fail to move in an square occupied to friend piece" do
            expect(@rook.legal_move(Move.new("Rf7"),["g","7"])).to be false
        end
        it "should fail to move in a square occupied to enemy piece if move is not a capture" do
            expect(@rook.legal_move(Move.new("Rf6"),["g","6"])).to be false
        end
        it "should fail if movement is not orthogonal" do
            expect(@rook.legal_move(Move.new("Rf6"),["g","5"])).to be false
        end
    end

    context "correct move" do
        it "should move along a free col " do
            expect(@rook.legal_move(Move.new("Rf1"),["f","4"])).to be true
        end
        it "should move along a free row" do
            expect(@rook.legal_move(Move.new("Rh4"),["f","4"])).to be true
        end
        it "shold capture a piece along a col" do
            expect(@rook.legal_move(Move.new("Rxf6"),["f","4"])).to be true
        end
        it "shold capture a piece along a row" do
            expect(@rook.legal_move(Move.new("Rxb4"),["f","4"])).to be true
        end
    end
    context "bad moves" do
        it "should fail to move along a not free row" do
            expect(@rook.legal_move(Move.new("Ra4"),["f","4"])).to be false
        end
        it "should fail to move along a not free col" do
            expect(@rook.legal_move(Move.new("Rf8"),["f","4"])).to be false
        end   
        it "shold fail to capture a piece if the road is not free" do
            expect(@rook.legal_move(Move.new("Rxf7"),["f","4"])).to be false
        end
    end

end