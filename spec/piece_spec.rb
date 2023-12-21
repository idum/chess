require "./lib/game"
require "./lib/piece"

# test for class Piece, interface for the other pieces. 
# Piece interface is intended to supply some common tests for legal_move and some utilities



describe "Piece" do
    context "easy part" do
        it "to_s function is correct" do
            piece1=Piece.new(avatar: "prova")
            expect(piece1.to_s).to eql "prova"
        end
    end
  
    context "legal_move test (general piece don't move)" do
        it "should be false if move is in an empty square" do
            expect(Piece.new.legal_move(["c","4"],["a","2"])).to be false
        end 
    end
end



