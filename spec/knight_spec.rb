require "./lib/move"
require "./lib/piece"

# class Knight define movement rule for chess piece Knight.
# Its peculiar trait is the "L" movement
# if the target location is occupied to friend piece, move is not possible. 
# in a capture move, target location is occupied by enemy piece.
# Eventual pieces (friend o enemy) along the movement are jumped 

describe "Knight" do
    before(:all) do
        @knight=Knight.new(color: "W")
        @knight1=Knight.new(color: "B")
        b={["e","5"] => Piece.new(color: "W"),
           ["e","3"] => Piece.new(color: "B"),
           ["e","4"] => @knight,   
           ["f","3"] => @knight1   
        }
        Move.start_position(b)
    end
    after(:all) do
        Move.reset!
    end

    context "correct move" do
        it "from e4 it can move in d6" do
            expect(@knight.legal_move(Move.new("Nd6"),["e","4"])).to be true
        end
        it "from e4 it can move in c5" do
            expect(@knight.legal_move(Move.new("Nc5"),["e","4"])).to be true
        end
        it "from e4 it can move in c3" do
            expect(@knight.legal_move(Move.new("Nc3"),["e","4"])).to be true
        end
        it "from e4 it can move in d2" do
            expect(@knight.legal_move(Move.new("Nd2"),["e","4"])).to be true
        end
        it "from e4 it can move in f6 and pieces in e3 f3 and e5 don't block movement" do
            expect(@knight.legal_move(Move.new("Nf6"),["e","4"])).to be true
        end
        it "from e4 it can move in g5 and pieces in e3 f3 and e5 don't block movement" do
            expect(@knight.legal_move(Move.new("Ng5"),["e","4"])).to be true
        end
        it "from e4 it can move in g3 and pieces in e3 f3 and e5 don't block movement" do
            expect(@knight.legal_move(Move.new("Ng3"),["e","4"])).to be true
        end
        it "from e4 it can move in f2 and pieces in e3 f3 and e5 don't block movement" do
            expect(@knight.legal_move(Move.new("Nf2"),["e","4"])).to be true
        end
        it "capture move Nxe5 from f3" do
            expect(@knight1.legal_move(Move.new("Nxe5"),["f","3"])).to be true
        end
    end
    
    context "bad moves" do
        it "target move cannot be same square of start one" do
            expect(@knight1.legal_move(Move.new("Nf3"),["f","3"])).to be false
        end
        it "cannot go to g3 from f3" do
            expect(@knight1.legal_move(Move.new("Ng3"),["f","3"])).to be false
        end
        it "cannot jump on enemy piece without capture flag" do
            expect(@knight1.legal_move(Move.new("Ne5"),["f","3"])).to be false
        end
        it "cannot jump on friendly piece without capture flag" do
            expect(@knight.legal_move(Move.new("Ne5"),["f","3"])).to be false
        end
        it "cannot jump on friendly piece with capture flag" do
            expect(@knight.legal_move(Move.new("Nxe5"),["f","3"])).to be false
        end
    end

end
