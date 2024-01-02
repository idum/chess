require "./lib/game"

# Class Queen define rules for Queen movement. A Queen can move on diagonals and orthogonal
# so you can check the correctness of the diagonal move, verifing if absolute distance of row and col of the move is equal
# For example Queen move from a2 to c4 is ok because |a-c|=|4-2|=2
# you can check also the correctness of orthogonal move, verifying that for starting and target square, one of row or col are equal.
# Queen cannot jump over other pieces, but it can capture, in a move capture a target enemy piece
# if the line from the bishop and the piece is free to run

describe "Queen" do
    before(:all) do
        @queen=Queen.new(color: "W")
        @queen1=Queen.new(color: "B")
        Game.position={["e","4"] => @queen,
           ["g","5"] => Bishop.new(color: "B"),
           ["e","3"] => Bishop.new(color: "W"),
           ["g","1"] => Bishop.new(color: "W"),
           ["h","5"] => Bishop.new(color: "W"),
           ["c","5"] => @queen1
        }
    end
    after(:all) do
        Game.reset!
    end
    context "base test" do
        context "base test" do
            it "should fail to move in starting square" do
                expect(@queen.legal_move(["e","4"],["e","4"])).to be false
            end
            it "should fail to move in an square occupied to friend piece" do
                expect(@queen1.legal_move(["g","5"],["c","5"])).to be false
            end
            it "should fail to move in a square occupied to enemy piece if move is not a capture" do
                expect(@queen1.legal_move(["e","3"],["c","5"])).to be false
            end
            it "should fail if movement is not diagonal and not orhtogonal" do
                expect(@queen.legal_move(["g","8"],["e","4"])).to be false
                expect(@queen.legal_move(["h","2"],["e","4"])).to be false
            end
        end
        context "correct moves" do
            it "should be correct a diagonal move up-right" do
                expect(@queen.legal_move(["g","6"],["e","4"])).to be true
            end
            it "should be correct a diagonal move up-left" do
                expect(@queen.legal_move(["b","7"],["e","4"])).to be true
            end
            it "should be correct a diagonal move down-right" do
                expect(@queen.legal_move(["h","1"],["e","4"])).to be true
            end
            it "should be correct a diagonal move down-left" do
                expect(@queen.legal_move(["c","2"],["e","4"])).to be true
            end

            it "should be correct a move along row" do
                expect(@queen.legal_move(["e","7"],["e","4"])).to be true
            end
            it "should be correct a move along col" do
                expect(@queen.legal_move(["h","4"],["e","4"])).to be true
            end
            it "should be correct capturing an enemy piece with no pieces along the move" do
                expect(@queen1.legal_move(["e","3"],["c","5"], capture: true)).to be true
            end
        end
        context "wrong moves" do
            it "should be false a move along a not free direction" do
                expect(@queen.legal_move(["e","1"],["e","4"])).to be false
            end
            it "should be false a capturing move along a not free direction" do
                expect(@queen1.legal_move(["g","1"],["c","5"], capture: true)).to be false
            end
        end
    end
    context "try_move and can_move_there?" do
        it "it should be possible because king is not present" do
            expect(@queen.legal_move(["g","6"],["e","4"])).to be true
            expect(@queen.try_move(["g","6"],["e","4"])).to be true
            expect(@queen.can_move_there?(["g","6"],["e","4"])).to be true
        end
        it "it should be possible because king is not threatened" do
            Game.position[["e","1"]]=King.new(color: "W")
            expect(@queen.legal_move(["g","6"],["e","4"])).to be true
            expect(@queen.try_move(["g","6"],["e","4"])).to be true
            expect(@queen.can_move_there?(["g","6"],["e","4"])).to be true
            Game.position.delete(["e","1"])
        end
        it "it should not be possible because king is threatened" do
            Game.position[["c","1"]]=King.new(color: "W")
            expect(@queen.legal_move(["g","6"],["e","4"])).to be true
            expect(Game.check_condition(@queen.color)).to be true
            expect(@queen.try_move(["g","6"],["e","4"])).to be false
            expect(@queen.can_move_there?(["g","6"],["e","4"])).to be false
        end
        it "now Queen is in e5 will capture enemy queen in c5 and remove the threat" do
            Game.position[["e","5"]]=@queen
            expect(@queen.legal_move(["c","5"],["e","5"], capture: true)).to be true
            expect(Game.check_condition(@queen.color)).to be true
            expect(@queen.try_move(["c","5"],["e","5"])).to be true
            expect(@queen.can_move_there?(["c","5"],["e","5"])).to be true
        end
        it "now even if Queen is in e5 will capture enemy queen in c5, there is another threat and move is not valid" do
            Game.position[["e","5"]]=@queen
            Game.position[["d","1"]]=Rook.new(color: "B")
            expect(@queen.legal_move(["c","5"],["e","5"], capture: true)).to be true
            expect(Game.check_condition(@queen.color)).to be true
            expect(@queen.try_move(["c","5"],["e","5"])).to be false
            expect(@queen.can_move_there?(["c","5"],["e","5"])).to be false
        end
        it "same move without enemy Rook, Queen capture in c5 with test flag = false, verify that the move if effectively done" do
            Game.position.delete(["d","1"])
            expect(@queen.try_move(["c","5"],["e","5"],test=false)).to be true
            expect(Game.position[["e","5"]]).to be nil
            expect(Game.position[["c","5"]]).to eql(@queen)
        end
    end
end 
