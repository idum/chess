require "./lib/game"


# Class Bishop define rules for Bishop movement. A Bishop can move on diagonals,
# so you can check the correctness of the move, verifing if absolute distance of row and col of the move is equal
# For example Bishop move from a2 to c4 is ok because |a-c|=|4-2|=2
# Bishop cannot jump over other pieces, but it can capture, in a move capture a target enemy piece
# if the line from the bishop and the piece is free to run

describe "Bishop" do
    before(:all) do
        @bishop=Bishop.new(color: "W")
        b={["d","7"] => Piece.new(color: "B"),
           ["f","4"] => @bishop,
           ["e","8"] => Bishop.new(color: "B"),
           ["h","3"] => Bishop.new(color: "W"),
           ["b","5"] => Piece.new(color: "B"),
           ["c","6"] => Piece.new
        }
        Game.position=b
    end
    after(:all) do
        Game.reset!
    end
    context "base test" do
        context "base test" do
            it "should fail to move in starting square" do
                expect(@bishop.legal_move(["f","4"],["f","4"])).to be false
            end
            it "should fail to move in an square occupied to friend piece" do
                expect(@bishop.legal_move(["d","7"],["e","8"])).to be false
            end
            it "should fail to move in a square occupied to enemy piece if move is not a capture" do
                expect(@bishop.legal_move(["h","3"],["d","7"])).to be false
            end
            it "should fail if movement is not diagonal" do
                expect(@bishop.legal_move(["f","5"],["g","8"])).to be false
                expect(@bishop.legal_move(["a","8"],["g","6"])).to be false
            end
        end
        context "correct moves" do
            it "should move diagonally right-up direction" do
                expect(@bishop.legal_move(["h","6"],["f","4"])).to be true
            end
            it "should move diagonally left-up direction" do
                expect(@bishop.legal_move(["b","8"],["f","4"])).to be true
            end
            it "should move diagonally left-down direction" do
                expect(@bishop.legal_move(["c","1"],["f","4"])).to be true
            end
            it "should move diagonally right-down direction" do
                expect(@bishop.legal_move(["h","2"],["f","4"])).to be true
            end
            it "should move capture a piece of different color while rest of diagonal is free" do
                expect(@bishop.legal_move(["d","7"],["h","3"],capture: true)).to be true
            end
        end
        context "bad moves" do
            it "should be false if some piece is along the diagonal" do
                expect(@bishop.legal_move(["a","4"],["e","8"])).to be false
            end
            it "should be false if try to capture a piece while diagonal is not free" do
                expect(@bishop.legal_move(["b","5"],["e","8"],capture: true)).to be false
            end
        end
    end
end
