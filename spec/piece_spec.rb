require "./lib/piece"
require "./lib/move"

# test for class Piece, interface for the other pieces. 
# Piece interface is intended to supply some common tests for legal_move and some utilities

# Test #1 banal parts. 

describe "Piece" do
    piece=Piece.new
    it "color should be getted and initialized with no values" do
        expect(piece.color).to eql("")
    end
    it "avatar should be getted and initialized with no values" do
        expect(piece.avatar).to eql("")
    end
    it "status should be getted and initialized with no values" do
        expect(piece.status).to eql("")
    end  
    it "to_s function is correct" do
        piece1=Piece.new(avatar: "prova")
        expect(piece1.to_s).to eql "prova"
    end
    it "set_color is correct" do
        piece.set_color "B"
        expect(piece.color).to eql "B"
    end

    piece1=Piece.new(color: "B")
    it "color should be getted and equal to assignment" do
        expect(piece1.color).to eql "B"
        
    end
end



# Test 2: test common "legal_move" parts

describe "Piece" do
    piece=Piece.new(color: "W")
    piece1=Piece.new(color: "B")
    Move.start_position={["a","4"] => piece, ["b","4"] => piece1}
    
    it "should be true if move is in an empty square" do
        move=Move.new("c4")
        expect(piece.legal_move(move,["a","2"])).to be true
    end

    it "should be false if the square target of the move coincide with the starting square" do
        move=Move.new("b4")
        expect(piece.legal_move(move,["b","4"])).to be false
    end

    it "should be false if the square target of the move is occupied to same_color piece" do
        move=Move.new("a4")
        expect(piece.legal_move(move,["b","2"])).to be false
    end

    it "should be (related to Piece test) true if the square target of the move is occupied to different_color piece" do
        move=Move.new("b4")
        expect(piece.legal_move(move,["b","2"])).to be true
    end

end



