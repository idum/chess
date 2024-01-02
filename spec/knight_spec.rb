require "./lib/game"

# class Knight define movement rule for chess piece Knight.
# Its peculiar trait is the "L" movement
# if the target location is occupied to friend piece, move is not possible. 
# in a capture move, target location is occupied by enemy piece.
# Eventual pieces (friend o enemy) along the movement are jumped 

describe "Knight" do
    before(:all) do
        @knight=Knight.new(color: "W")
        @knight1=Knight.new(color: "B")
        Game.position={["e","5"] => Piece.new(color: "W"),
           ["e","3"] => Piece.new(color: "B"),
           ["e","4"] => @knight,   
           ["f","3"] => @knight1   
        }
        
    end
    after(:all) do
        Game.reset!
    end

    context "correct move" do
        it "from e4 it can move in d6" do
            expect(@knight.legal_move(["d","6"],["e","4"])).to be true
        end
        it "from e4 it can move in c5" do
            expect(@knight.legal_move(["c","5"],["e","4"])).to be true
        end
        it "from e4 it can move in c3" do
            expect(@knight.legal_move(["c","3"],["e","4"])).to be true
        end
        it "from e4 it can move in d2" do
            expect(@knight.legal_move(["d","2"],["e","4"])).to be true
        end
        it "from e4 it can move in f6 and pieces in e3 f3 and e5 don't block movement" do
            expect(@knight.legal_move(["f","6"],["e","4"])).to be true
        end
        it "from e4 it can move in g5 and pieces in e3 f3 and e5 don't block movement" do
            expect(@knight.legal_move(["g","5"],["e","4"])).to be true
        end
        it "from e4 it can move in g3 and pieces in e3 f3 and e5 don't block movement" do
            expect(@knight.legal_move(["g","3"],["e","4"])).to be true
        end
        it "from e4 it can move in f2 and pieces in e3 f3 and e5 don't block movement" do
            expect(@knight.legal_move(["f","2"],["e","4"])).to be true
        end
        it "capture move Nxe5 from f3" do
            expect(@knight1.legal_move(["e","5"],["f","3"],capture: true)).to be true
        end
    end
    
    context "bad moves" do
        it "target move cannot be same square of start one" do
            expect(@knight1.legal_move(["f","3"],["f","3"])).to be false
        end
        it "cannot go to g3 from f3" do
            expect(@knight1.legal_move(["g","3"],["f","3"])).to be false
        end
        it "cannot jump on enemy piece without capture flag" do
            expect(@knight1.legal_move(["e","5"],["f","3"])).to be false
        end
        it "cannot jump on friendly piece without capture flag" do
            expect(@knight.legal_move(["e","5"],["f","3"])).to be false
        end
        it "cannot jump on friendly piece with capture flag" do
            expect(@knight.legal_move(["e","5"],["f","3"],capture: true)).to be false
        end
    end
    context "try_move and can_move_there?" do
        it "it should be possible because king is not present" do
            expect(@knight.legal_move(["d","6"],["e","4"])).to be true
            expect(@knight.try_move(["d","6"],["e","4"])).to be true
            expect(@knight.can_move_there?(["d","6"],["e","4"])).to be true
        end
        it "it should be possible because king is not threatened" do
            Game.position[["d","1"]]=King.new(color: "W")
            expect(@knight.legal_move(["d","6"],["e","4"])).to be true
            expect(Game.check_condition(@knight.color)).to be false
            expect(@knight.try_move(["d","6"],["e","4"])).to be true
            expect(@knight.can_move_there?(["d","6"],["e","4"])).to be true
            Game.position.delete(["d","1"])
        end
        it "it should not be possible because king is threatened" do
            Game.position[["d","4"]]=King.new(color: "W")
            expect(@knight.legal_move(["d","6"],["e","4"])).to be true
            expect(Game.check_condition(@knight.color)).to be true
            expect(@knight.try_move(["d","6"],["e","4"])).to be false
            expect(@knight.can_move_there?(["d","6"],["e","4"])).to be false
        end
        it "now @knight is in d2. He can capture enemy knight in f3 and remove the threat" do
            Game.position[["d","2"]]=@knight
            expect(@knight.legal_move(["f","3"],["d","2"], capture: true)).to be true
            expect(Game.check_condition(@knight.color)).to be true
            expect(@knight.try_move(["f","3"],["d","2"])).to be true
            expect(@knight.can_move_there?(["f","3"],["d","2"])).to be true
        end
        it "same move, with test flag = false, verify that the move if effectively done" do
            expect(@knight.try_move(["f","3"],["d","2"],test=false)).to be true
            expect(Game.position[["d","2"]]).to be nil
            expect(Game.position[["f","3"]]).to eql(@knight)
        end
    end

end
