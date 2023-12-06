require "./lib/move"

# rspec test for class Move.
# class Move manage the game flux. Main function is to grab actual move, validate it and execute it, adjourning piece position and verify game end.
# as Class methods and variable, it also manage history of the game. 
# 
# test #1: Class methods and variable

describe Move do
    before(:all) do
        piece=Piece.new(color: "W")
        piece1=Piece.new(color: "B")
        a=[]
        a.push( {"a3" => {["a","3"] => piece, ["b","7"] => piece1}})
        a.push({"b6" => {["a","3"] => piece, ["b","6"] => piece1}})
        a.push({"a4" =>  {["a","4"] => piece, ["b","6"] => piece1}})
        @b={["a","4"] => piece, ["b","6"] => piece1}
        Move.load_game(a)
    end

    it "actual turn should be 2" do
        expect(Move.actual_turn).to eql 2
    end

    it "white_move? shold be false" do
        expect(Move.white_move?).to be false
    end

    it "move_stack should be the b array" do
        b=["a3","b6","a4"]
        expect(Move.move_stack).to eql(b)
    end

    it "position should be last position, as @b" do
        expect(Move.position).to eql(@b)
    end

    it "show the last move" do
        expect(Move.last_move).to eql("a4")
    end
      
end

#part 2: test on move istance (PARTIAL: LEGAL MOVE IS NOT TESTED, REQUIRE FIRST TO VALIDATE PIECE subclasses)

describe Move do
    context "correct moves" do
        it "a) resign word" do
            expect{move=Move.new("resign")}.not_to raise_error
        end
        it "b) o-o" do
            expect{@move=Move.new("o-o")}.not_to raise_error
            expect(@move.castling).to eql("short")
            expect(@move.piece_sym).to eql "K"
        end
        it "b) o-o-o" do
            expect{@move=Move.new("O-O-O")}.not_to raise_error
            expect(@move.castling).to eql "long"
            expect(@move.piece_sym).to eql "K"
        end
        it "c) standard notation: [QKRBN][col][row]" do
            expect{@move=Move.new("Qb4")}.not_to raise_error
            expect(@move.piece_sym).to eql "Q"
            expect(@move.coordinates).to eql(["b","4"])
        end
        it "d) standard notation for pawn: [col][row]" do
            expect {@move=Move.new("a7")}.not_to raise_error
            expect(@move.piece_sym).to eql "P"
            expect(@move.coordinates).to eql(["a","7"])
        end
        it "e) standard capture move: [QKRBN]x[col][row]" do
            expect {@move=Move.new("Nxf2")}.not_to raise_error
            expect(@move.piece_sym).to eql "N"
            expect(@move.coordinates).to eql(["f","2"])
            expect(@move.capture).to be true
        end  
        it "f) standard notation for pawn capture move: [starting col]x[col][row]" do
            expect {@move=Move.new("cxd4")}.not_to raise_error
            expect(@move.piece_sym).to eql "P"
            expect(@move.spec).to eql "c"
            expect(@move.coordinates).to eql(["d","4"])
            expect(@move.capture).to be true
        end
        it "f) very rare case notation for pawn capture move: [starting col][starting row]x[col][row]" do
            expect {@move=Move.new("c3xd4")}.not_to raise_error
            expect(@move.piece_sym).to eql "P"
            expect(@move.spec).to eql "c3"
            expect(@move.coordinates).to eql(["d","4"])
            expect(@move.capture).to be true
        end

        it "g) move notation when more pieces can do the move: [QKRBN][starting col/row][col][row]" do
            expect {@move=Move.new("Rde7")}.not_to raise_error
            expect(@move.piece_sym).to eql "R"
            expect(@move.spec).to eql "d"
            expect(@move.coordinates).to eql(["e","7"])
        end
        it "h) move notation when more pieces can do the capturing move: [QKRBN][starting col/row]x[col][row]" do
            expect {@move=Move.new("Rdxe7")}.not_to raise_error
            expect(@move.piece_sym).to eql "R"
            expect(@move.spec).to eql "d"
            expect(@move.coordinates).to eql(["e","7"])
            expect(@move.capture).to be true
        end
        it "i) pawn promotion move:[col][row]=[QKRBN]" do
            expect {@move=Move.new("a8=Q")}.not_to raise_error
            expect(@move.piece_sym).to eql "P"
            expect(@move.promote).to eql "Q"
            expect(@move.coordinates).to eql(["a","8"])
        end
        it "i) pawn promotion capture move:[starting col]x[col][row]=[QKRBN]" do
            expect {@move=Move.new("bxa8=Q")}.not_to raise_error
            expect(@move.piece_sym).to eql "P"
            expect(@move.promote).to eql "Q"
            expect(@move.coordinates).to eql(["a","8"])
            expect(@move.spec).to eql "b"
            expect(@move.capture).to be true
        end
    end
    #context "bad moves" do
    #    it "col outside board" do
    #        expect {move=Move.new("k3")}.to raise_error(BadMoveError)
    #    end
    #    it "row outside board" do
    #        expect {move=Move.new("a9")}.to raise_error(Errors::BadMoveError)
    #    end
    #    it "not recognized piece" do
    #        expect {move=Move.new("Jf4")}.to raise_error(Errors::BadMoveError)
    #    end
    #    it "format capture not correct" do
    #        expect {move=Move.new("N+f3")}.to raise_error(Errors::BadMoveError)
    #    end
    #end
end
