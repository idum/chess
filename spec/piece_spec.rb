# we will test base class Piece.
# a Piece is an element of chess. 
# Mainly it describe color: "W" and "B". Capitalized char.
# The starting position 
# the status: captured or not, and if not captured the actual position on the board
require './lib/piece'

piece = Piece.new

# test init
describe Piece do
    it "return color of the piece" do
        expect(piece.color).to eql("W")
    end
    it "return position of the piece" do
        expect(piece.position).to eql("out")
    end
    it "return status of the piece" do
        expect(piece.status).to eql("init")
    end
end

#test attribute assignation. Color can be only "B" or "W", status can be only "init", "ingame", "capt"
#position can be only "out" or a char from a to h + a number from 1 to 8
#right assignation modify the attribute and produce "true", wrong assignation don't modify attribute and produce "false"

describe Piece do
    describe "#set_color" do
        it "return false if wrong assignation" do
            a=piece.color
            expect(piece.set_color "g").to be false
            expect(piece.color).to eql(a)
        end
        it "return true if good assignation" do
            expect(piece.set_color "B").to be true
            expect(piece.color).to eql("B")
        end
    end
    describe "#set_status" do
        it 'return false if wrong assignation' do
            a=piece.status
            expect(piece.set_status "grounded").to be false
            expect(piece.status).to eql(a)
        end
        it 'return true if right assignation' do
            expect(piece.set_status 'ingame').to be true
            expect(piece.status).to eql('ingame')
            expect(piece.set_status 'capt').to be true
            expect(piece.status).to eql('capt')
            expect(piece.set_status 'init').to be true
            expect(piece.status).to eql('init')
        end
    end
    describe "#set_position" do
        it 'return false with casual input' do
            expect(piece.set_position 'sirue').to be false
        end
        it 'return false with 2-char not regular move' do
            expect(piece.set_position 'm9').to be false
        end
        it 'return false with inverted char move' do
            expect(piece.set_position '3e').to be false
        end
        it 'return true with correct move' do
            expect(piece.set_position 'e4').to be true
            expect(piece.position).to eql('e4')
        end
        it 'return true if "out" input' do
            expect(piece.set_position 'out').to be true
            expect(piece.position).to eql('out')
        end
    end

end