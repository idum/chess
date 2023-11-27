# Class GameManager is the base class of the app. It manage all the game, from creating the board to read the moves
# execute the move and control end game conditions
# In this first develop cycle, we accept input from stdin as string; the move will be checked and executed
# and the output will be the board (as sequence of strings) and the eventual end-game condition
# We will provide a log command for recall all the moves.
# In eventual following develop cycles we will try to implement html page with graphical improvements.

class GameManager
    def initialize(input="stdin", output="stdout",variant="classic")
        @input=input
        @output=output
        @board=Hash.new
        @status="idle"
        setup_board(variant)
    end

    def setup_board(*variant)
        #this method is the crossway for different variant setup. Here we have only one variant: classic
        return "Sorry, this variant is not (yet?) implemented" if variant!="classic"
        setup_classic
        @status="game"
    end





    private
    def setup_classic
        #build base section
        'a'.upto 'h' do |col|
            '3'.upto '6' do |row|











end
