 require "./lib/game"

 # Class Game is an utility class for the game. It manage the game history
 # It is not meant to be istantiated, his use is by class methods
  
 describe "Game" do
    after(:all) do
        Game.reset!
    end
    context "base test" do
        before do
            @piece=Piece.new(color: "W")
            @piece1=Piece.new(color: "B")
            @a=[]
            @a.push( {"a3" => {["a","3"] => @piece, ["b","7"] => @piece1}})
            @a.push({"b6" => {["a","3"] => @piece, ["b","6"] => @piece1}})
            @a.push({"a4" =>  {["a","4"] => @piece, ["b","6"] => @piece1}})
            @b={["a","4"] => @piece, ["b","6"] => @piece1}
            Game.load_game(@a)
        end 

        it "history should be as @a" do
            expect(Game.history).to eql(@a)
        end
        it "position should be as @b" do
            expect(Game.position).to eql(@b)
        end
        it "status should be game" do
            expect(Game.status).to eql("game")
        end

        it "actual turn should be 2" do
            expect(Game.actual_turn).to eql(2)
        end
        it "who_move should be B" do    
            expect(Game.who_move).to eql("B")
        end
        it "move_stack should be ['a3','b6','a4'] " do
            expect(Game.move_stack).to eql(["a3","b6","a4"])
        end
        it "last_move should be a4" do
            expect(Game.last_move).to eql("a4")
        end
        it "goto_turn should go to turn 1, move to B" do
            Game.goto_turn(1,"B")
            h=[{"a3" => {["a","3"] => @piece, ["b","7"] => @piece1}}]
            po={["a","3"] => @piece, ["b","7"] => @piece1}
            expect(Game.history).to eql(h)
            expect(Game.position).to eql(po)
            expect(Game.who_move).to eql("B")
            expect(Game.actual_turn).to eql(1)
        end
        it "turn_back should go back a turn" do
            Game.turn_back
            po={["a","3"] => @piece, ["b","6"] => @piece1}
            h=[{"a3" => {["a","3"] => @piece, ["b","7"] => @piece1}},
                {"b6" => {["a","3"] => @piece, ["b","6"] => @piece1}}]
            expect(Game.history).to eql(h)
            expect(Game.position).to eql(po)
            expect(Game.who_move).to eql("W")
            expect(Game.actual_turn).to eql(2)
        end
      
        it "reset! should restart the history" do
            Game.reset!
            expect(Game.history).to eql([])
            expect(Game.position).to eql({})
            expect(Game.who_move).to eql("W")
            expect(Game.actual_turn).to eql(1)
        end
    end
    context "repetition_draw" do
        before do
            a={
                ["a","1"] => Piece.new,
                ["a","2"] => Piece.new(color: "B")
            }
            b={
                ["a","3"] => Piece.new
            }
            Game.history=[{"a1" => a}, {"a2" => b}, {"a3" => a}, {"a4" => b}, {"a5" => a}]
        end

        it "should be true: position a is present 3 times" do
            expect(Game.repetition_draw).to be true
        end
        it "should be false if we turn back" do
            Game.turn_back
            expect(Game.repetition_draw).to be false
        end
    end
end