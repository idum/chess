
require "./lib/piece"

# Class King define King movement rules. King base movement is a square in any directions.
# Special move is the Castling, short and long, that need some pre-conditions, as in the class.
# Mayor constrain for King movement is that it cannot move in a square that is threated by enemy pieces.
# Chess, Chessmate and Stalemate rules will managed by move class


describe "King" do
   
    after(:all) do
        Game.reset!
    end

    context "basic move test" do
        before do
            @king=King.new(color: "W")
            Game.position={["e","4"] => @king,
            }
           
        end
        it "should fail to move in starting square" do
            expect(@king.legal_move(["e","4"],["e","4"])).to be false
        end
   
        it "should move 1 square orthogonal e4->e3" do
            expect(@king.legal_move(["e","3"],["e","4"])).to be true
        end
        it "should move 1 square orthogonal e4->e5" do
            expect(@king.legal_move(["e","5"],["e","4"])).to be true
        end   
        it "should move 1 square orthogonal e4->f4" do
            expect(@king.legal_move(["f","4"],["e","4"])).to be true
        end
        it "should move 1 square orthogonal e4->d4" do
            expect(@king.legal_move(["d","4"],["e","4"])).to be true
        end
        it "should move 1 square diagonally e4->f3" do
            expect(@king.legal_move(["f","3"],["e","4"])).to be true
        end
        it "should move 1 square diagonally e4->f5" do
            expect(@king.legal_move(["f","5"],["e","4"])).to be true
        end
        it "should move 1 square diagonally e4->d3" do
            expect(@king.legal_move(["d","3"],["e","4"])).to be true
        end
        it "should move 1 square diagonally e4->d5" do
            expect(@king.legal_move(["d","5"],["e","4"])).to be true
        end
    end
    context "move constrains (not threatened squares)" do
        before do
            @king=King.new(color: "W")
            Game.position={["e","4"] => @king,
               ["d","3"] => Piece.new(color: "W"),
               ["d","5"] => Piece.new(color: "B")
            }
           
        end

        it "should fail to move in an square occupied to friend piece" do
            expect(@king.legal_move(["d","3"],["e","4"])).to be false
        end
        it "should fail to move in a square occupied to enemy piece if move is not a capture" do
            expect(@king.legal_move(["d","5"],["e","4"])).to be false
        end
        it "should capture the undefended piece" do
            expect(@king.legal_move(["d","5"],["e","4"],capture: true)).to be true
        end
        
    end

    context "castling" do
        before do
            @king=King.new(color: "W")
            Game.position={["e","1"] => @king,
               ["h","1"] => Rook.new(color: "W"),
               ["a","1"] => Rook.new(color: "W"),
            }
           
        end
        it "should short castling " do
            expect(@king.legal_move([],["e","1"],castling: "short")).to be true
        end
        it "should long castling " do
            expect(@king.legal_move([],["e","1"],castling: "long")).to be true
        end
        it "should don't allow short castling is Rook is moved" do
            Game.position[["h","1"]].status="moved"
            expect(@king.legal_move([],["e","1"],castling: "short")).to be false
        end
        it "should don't allow short castling is King is moved" do
            Game.position[["e","1"]].status="moved"
            expect(@king.legal_move([],["e","1"],castling: "long")).to be false
        end
        it "should don't allow short castling if King is not in the required square" do
            Game.position.delete(["e","1"])
            expect(@king.legal_move([],["e","1"],castling: "short")).to be false
        end
        it "should don't allow short castling if Rook is not in the required square" do
            Game.position[["e","1"]]=@king
            Game.position.delete(["h","1"])
            expect(@king.legal_move([],["e","1"],castling: "short")).to be false
        end
    end
    
    context "threatened squares" do
        before do
            @king=King.new(color: "W")
            Game.position={["e","1"] => @king,
               ["a","1"] => Rook.new(color: "W"),
               ["c","3"] => Knight.new(color: "B"),
               ["d","2"] => Bishop.new(color: "B"),
               ["e","3"] => Pawn.new(color:"B")            
            }
            
        end
        it "should not move in d1" do
            expect(@king.legal_move(["d","1"],["e","1"])).to be false
        end
        it "should not capture in d2" do
            expect(@king.legal_move(["d","2"],["e","1"],capture: true)).to be false
        end
        it "should not castle if one castling square is under attack" do
            expect(@king.legal_move([],["e","1"],castling: "short")).to be false
        end
    end
    context "try_move" do
        before do
            @king=King.new(color: "W")
            Game.position={
                ["e","1"] => @king,
                ["a","1"] => Rook.new(color: "W"),
                ["h","1"] => Rook.new(color: "W")
            }
        end
        # king moves are naturally checked for threats in movement in legal_move. Here is supposed that that control is made
        it "@king should complete move in d1" do
            expect(@king.try_move(["d","1"],["e","1"], test=false)).to be true
            expect(Game.position[["d","1"]]).to eql(@king)
            expect(Game.position[["e","1"]]).to be nil
            expect(@king.status).to eql "moved"
        end
        it "@king should long castling" do
            expect(@king.try_move("","",test=false, castling:"long")).to be true
            expect(Game.position[["c","1"]]).to eql(@king)
            expect(Game.position[["e","1"]]).to be nil
            expect(@king.status).to eql "moved"
            expect(Game.position[["d","1"]].class).to eql(Rook)
            expect(Game.position[["a","1"]]).to be nil
            expect(Game.position[["d","1"]].status).to eql "moved"
        end
        it "@king should short castling" do
            expect(@king.try_move("","",test=false, castling:"short")).to be true
            expect(Game.position[["g","1"]]).to eql(@king)
            expect(Game.position[["e","1"]]).to be nil
            expect(@king.status).to eql "moved"
            expect(Game.position[["f","1"]].class).to eql(Rook)
            expect(Game.position[["h","1"]]).to be nil
            expect(Game.position[["f","1"]].status).to eql "moved"
        end

    end

end