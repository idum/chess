require "./lib/move"
require "./lib/piece"

# test for class Piece, interface for the other pieces. 
# Piece interface is intended to supply some common tests for legal_move and some utilities



describe "Piece" do
    before(:all) do
        @piece=Piece.new(color: "W")
        piece1=Piece.new(color: "B")
        Move.start_position({["a","4"] => @piece, ["b","4"] => piece1})
    end
    after(:all) do
        Move.reset!
    end

    context "easy part" do
        it "to_s function is correct" do
            piece1=Piece.new(avatar: "prova")
            expect(piece1.to_s).to eql "prova"
        end
    end
  
    context "legal_move test (general piece don't move)" do
        it "should be false if move is in an empty square" do
            expect(@piece.legal_move(Move.new("Nc4"),["a","2"])).to be false
        end

        it "should be false if the square target of the move coincide with the starting square" do
            expect(@piece.legal_move(Move.new("b4"),["b","4"])).to be false
        end

        it "should be false if the square target of the move is occupied to same_color piece" do
            expect(@piece.legal_move(Move.new("a4"),["b","2"])).to be false
        end

        it "should be false if the square target of the move is occupied to different_color piece" do
            expect(@piece.legal_move(Move.new("Nxb4"),["b","2"])).to be false
        end

     end
end



