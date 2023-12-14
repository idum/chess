require "./lib/move"
require "./lib/piece"

# Class King define King movement rules. King base movement is a square in any directions.
# Special move is the Castling, short and long, that need some pre-conditions, as in the class.
# Mayor constrain for King movement is that it cannot move in a square that is threated by enemy pieces.
# Chess, Chessmate and Stalemate rules will managed by move class


describe "King" do
   
    after(:all) do
        Move.reset!
    end

    context "basic move test" do
        before do
            @king=King.new(color: "W")
            b={["e","4"] => @king,
            }
            Move.start_position(b)
        end
        it "should fail to move in starting square" do
            expect(@king.legal_move(Move.new("Ke4"),["e","4"])).to be false
        end
   
        it "should move 1 square orthogonal e4->e3" do
            expect(@king.legal_move(Move.new("Ke3"),["e","4"])).to be true
        end
        it "should move 1 square orthogonal e4->e5" do
            expect(@king.legal_move(Move.new("Ke5"),["e","4"])).to be true
        end   
        it "should move 1 square orthogonal e4->f4" do
            expect(@king.legal_move(Move.new("Kf4"),["e","4"])).to be true
        end
        it "should move 1 square orthogonal e4->d4" do
            expect(@king.legal_move(Move.new("Kd4"),["e","4"])).to be true
        end
        it "should move 1 square diagonally e4->f3" do
            expect(@king.legal_move(Move.new("Kf3"),["e","4"])).to be true
        end
        it "should move 1 square diagonally e4->f5" do
            expect(@king.legal_move(Move.new("Kf5"),["e","4"])).to be true
        end
        it "should move 1 square diagonally e4->d3" do
            expect(@king.legal_move(Move.new("Kd3"),["e","4"])).to be true
        end
        it "should move 1 square diagonally e4->d5" do
            expect(@king.legal_move(Move.new("Kd5"),["e","4"])).to be true
        end
    end
    context "base capturing moves" do
        before do
            @king=King.new(color: "W")
            b={["e","4"] => @king,
               ["d","3"] => Piece.new(color: "W"),
               ["d","5"] => Piece.new(color: "B")
            }
            Move.start_position(b)
        end

        it "should fail to move in an square occupied to friend piece" do
            expect(@king.legal_move(Move.new("Kd3"),["e","4"])).to be false
        end
        it "should fail to move in a square occupied to enemy piece if move is not a capture" do
            expect(@king.legal_move(Move.new("Kd5"),["e","4"])).to be false
        end
        it "should capture the undefended piece" do
            expect(@king.legal_move(Move.new("Kxd5"),["e","4"])).to be true
        end
    end

    context "castling" do
        before do
            @king=King.new(color: "W")
            b={["e","1"] => @king,
               ["h","1"] => Rook.new(color: "W"),
               ["a","1"] => Rook.new(color: "W"),
            }
            Move.start_position(b)
        end
        it "should short castling " do
            expect(@king.legal_move(Move.new("o-o"),["e","1"])).to be true
        end
        it "should long castling " do
            expect(@king.legal_move(Move.new("O-O-O"),["e","1"])).to be true
        end
        it "should don't allow short castling is Rook is moved" do
            Move.position[["h","1"]].status="moved"
            expect(@king.legal_move(Move.new("o-o"),["e","1"])).to be false
        end
        it "should don't allow short castling is King is moved" do
            Move.position[["e","1"]].status="moved"
            expect(@king.legal_move(Move.new("o-o-o"),["e","1"])).to be false
        end
        it "should don't allow short castling if King is not in the required square" do
            Move.position.delete(["e","1"])
            expect(@king.legal_move(Move.new("o-o"),["e","1"])).to be false
        end
        it "should don't allow short castling if Rook is not in the required square" do
            Move.position[["e","1"]]=@king
            Move.position.delete(["h","1"])
            expect(@king.legal_move(Move.new("o-o"),["e","1"])).to be false
        end
    end
    
    context "threatened squares" do
        before do
            Move.reset!
            @king=King.new(color: "W")
            b={["e","1"] => @king,
               ["a","1"] => Rook.new(color: "W"),
               ["c","3"] => Knight.new(color: "B"),
               ["d","2"] => Bishop.new(color: "B"),
               ["e","3"] => Pawn.new(color:"B")
               
            }
            Move.start_position(b)
        end
        it "should not move in d1" do
            expect(@king.legal_move(Move.new("Kd1"),["e","1"])).to be false
        end
        it "should not capture in d2" do
            expect(@king.legal_move(Move.new("Kxd2"),["e","1"])).to be false
        end
        it "should not castle if one castling square is under attack" do
            expect(@king.legal_move(Move.new("o-o"),["e","1"])).to be false
        end
    end
end