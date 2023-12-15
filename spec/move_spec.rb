require "./lib/move"

# rspec test for class Move.
# class Move manage the game flux. Main function is to grab actual move, validate it and execute it, adjourning piece position and verify game end.
# as Class methods and variable, it also manage history of the game. 
# 
# test #1: Class methods and variable

describe "Move" do
    after :all do
        Move.reset!
    end
    context "base test" do
        before do
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

        it "who_move shold be Black" do
            expect(Move.who_move).to eql("B")
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
    context "test correct move input" do
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
    context "bad move input" do
        it "col outside board" do
            expect {move=Move.new("k3")}.to raise_error(BadMoveError)
        end
        it "row outside board" do
            expect {move=Move.new("a9")}.to raise_error(BadMoveError)
        end
        it "not recognized piece" do
            expect {move=Move.new("Jf4")}.to raise_error(BadMoveError)
        end
        it "format capture not correct" do
            expect {move=Move.new("N+f3")}.to raise_error(BadMoveError)
        end
        
    end
    describe "threatened_square method" do
        before do
            Move.position={
                ["a","1"] => Rook.new(color: "B"),
                ["a","3"] => Piece.new(color: "B"),
                ["g","1"] => Rook.new(color: "W")
            }
            @move=Move.new("a4")
            
        end
        after do
            Move.reset!
        end

        context "correct threats" do
            it "Rook threat f1" do
                expect(@move.threatened_square(["f","1"],"W")).to be true
            end
            it "Rook threat h1 even if in g1 there is a friendly piece" do
                expect(@move.threatened_square(["a","3"],"W")).to be true
            end
            it "Rook don't threat h1 because it don't reach the square" do
                expect(@move.threatened_square(["h","1"],"W")).to be false
            end
        end
    end    
    describe "legal_move method" do
        before do
            Move.reset!
            Move.position={
                ["a","1"] => Rook.new(color: "W"),
                ["c","5"] => Rook.new(color: "W"),
                ["a","8"] => Rook.new(color: "W"),
                ["b","6"] => Rook.new(color: "B"),
                ["c","8"] => Piece.new(color: "B")
            }
        end
        after do
            Move.reset!
        end
        context "correct moves" do
            it "Rook in c5 is the only piece that can move in c7 and it will do" do
                move=Move.new("Rc7")
                expect(move.legal_move).to eql(["c","5"])
            end
            it "Rook in c5 is the only white piece that can move in b5 and it will do" do
                move=Move.new("Rb5")
                expect(move.legal_move).to eql(["c","5"])
            end
            it "Rcc1 means that it will be the Rook in c5 to move in c1 and not the one in a1" do
                move=Move.new("Rcc1")
                expect(move.legal_move).to eql(["c","5"])
            end
            it "Rac1 means that it will be the Rook in a1 to move in c1 and not the one in c5" do
                move=Move.new("Rac1")
                expect(move.legal_move).to eql(["a","1"])
            end
            it "R1a3 means that it will be the Rook in a1 to move in a3" do
                move=Move.new("R1a3")
                expect(move.legal_move).to eql(["a","1"])
            end
            it "R1xc8 means that it will be the Rook in a1 to capture the piece in c8" do
                move=Move.new("Raxc8")
                expect(move.legal_move).to eql(["a","8"])
            end
            it "Ra1a5 will move the right Rook in a1 even if 3 pieces can reach a5 " do
                move=Move.new("Ra1a5")
                expect(move.legal_move).to eql(["a","1"])
            end
        end
        context "bad cases" do
            it "Nf1 should produce NP = not possible move, because there is not a Knight on the board" do
                move=Move.new("Nf1")
                expect(move.legal_move).to eql("NP")
            end
            it "Rf3 should produce NP = not possible move, because no Rooks on the board can reach f3" do
                move=Move.new("Rf3")
                expect(move.legal_move).to eql("NP")
            end
            it "Rh6 should produce NP = not possible move, because no White Rooks on the board can reach h6 (but a black rook yes)" do
                move=Move.new("Rh6")
                expect(move.legal_move).to eql("NP")
            end
            it "Ra5 should produce NR = not recognized piece, because 3 pieces can reach a5 and there is no notation to resolve the dubt" do
                move=Move.new("Ra5")
                expect(move.legal_move).to eql("NR")
            end
            it "Raa5 should produce NR = not recognized piece, because 3 pieces can reach a5 and the notation don't resolve dubt" do
                move=Move.new("Ra5")
                expect(move.legal_move).to eql("NR")
            end
            it "Raa5 should produce NR = not recognized piece, because there are 2 Rooks in col a that can reach a5" do
                move=Move.new("Ra5")
                expect(move.legal_move).to eql("NR")
            end
        end
    end
    describe "make_move (white turn)" do
        before do
            Move.reset!
            Move.position={
                ["e","1"] => King.new(color: "W"),
                ["a","1"] => Rook.new(color: "W"),
                ["h","1"] => Rook.new(color: "W"),
                ["h","2"] => Pawn.new(color: "W"),
                ["e","6"] => Queen.new(color: "B"),
                ["e","4"] => Knight.new(color: "W")
            }
        end
        after do
            Move.reset!
        end
        context "correct moves" do
            it "Queen should move in b6 without problem" do
                move=Move.new("Qb6")
                expect(move.make_move(["e","6"])).to be true
                expect(Move.position[["b","6"]].class).to eql(Queen)
                expect(Move.position[["e","6"]]).to be nil
            end
            it "pawn will do 2-square move and his status will be actual turn" do
                move=Move.new("h4")
                expect(move.make_move(["h","2"])).to be true
                expect(Move.position[["h","4"]].class).to eql(Pawn)
                expect(Move.position[["h","2"]]).to be nil
                expect(Move.position[["h","4"]].status).to eql(Move.actual_turn.to_s)
            end
            it "pawn will do 1-square move and his status will be moved" do
                move=Move.new("h3")
                expect(move.make_move(["h","2"])).to be true
                expect(Move.position[["h","3"]].class).to eql(Pawn)
                expect(Move.position[["h","2"]]).to be nil
                expect(Move.position[["h","3"]].status).to eql("moved")
            end
            it "short Castling is made correctly " do
                move=Move.new("o-o")
                expect(move.make_move(["",""])).to be true
                expect(Move.position[["g","1"]].class).to eql(King)
                expect(Move.position[["g","1"]].status).to eql("moved")
                expect(Move.position[["e","1"]]).to be nil
                expect(Move.position[["f","1"]].class).to eql(Rook)
                expect(Move.position[["f","1"]].status).to eql("moved")
                expect(Move.position[["h","1"]]).to be nil
            end
            it "long Castling is made correctly " do
                move=Move.new("o-o-o")
                expect(move.make_move(["",""])).to be true
                expect(Move.position[["c","1"]].class).to eql(King)
                expect(Move.position[["c","1"]].status).to eql("moved")
                expect(Move.position[["e","1"]]).to be nil
                expect(Move.position[["d","1"]].class).to eql(Rook)
                expect(Move.position[["d","1"]].status).to eql("moved")
                expect(Move.position[["a","1"]]).to be nil
            end
        end
        context "move causing king on-check condition" do
            it "Knight cannot move in c3 because it put his King under check by Queen" do
                move=Move.new("Nc3")
                expect(move.make_move(["e","4"])).to eql("KC")
            end
            it "Queen is now in d1; Knight cannot move in c3 because king is under Check" do
                Move.position.delete(["e","6"])
                Move.position[["d","1"]]=Queen.new(color: "B")
                move=Move.new("Nc3")
                expect(move.make_move(["e","4"])).to eql("KC")
            end
            it "Queen is now in d2, menacing King; Knight can capture it in d2 and remove threat" do
                Move.position.delete(["e","6"])
                Move.position[["d","2"]]=Queen.new(color: "B")
                move=Move.new("Nxd2")
                expect(move.make_move(["e","4"])).to be true
            end
        end
    end
end
