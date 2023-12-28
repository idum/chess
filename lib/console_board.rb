# With this class we build the board and we produce the relative output
# we consider 3 different output: HTML, Console, Json
# In this first round of developing we work on console output
# For console, we use Rainbow gem for colorize the text

require "rainbow"
require_relative "move"
require_relative "game"


class ConsoleBoard 
    attr_reader :status, :board, :start_position, :media
    
    WHITESPACECOLOR="6495ED"
    BLACKSPACECOLOR="00FFFF"
    def initialize(variant="classic",media="console")
        @media=media
        @board=Hash.new{}
        color=WHITESPACECOLOR
        "1".upto "8" do |r|
            row=r.to_s
            "a".upto "h" do |col|
                @board[[col,row]] = color
                color==WHITESPACECOLOR ? color=BLACKSPACECOLOR : color=WHITESPACECOLOR
            end
            color==WHITESPACECOLOR ? color=BLACKSPACECOLOR : color=WHITESPACECOLOR
        end
        setup_board(variant)
    end

    def show_game
        case media
        when "console" then putconsole
        end
    end

    def take_move
        case media
        when "console" then getconsole
        end
    end

    def putconsole
        #building the board as string
        st="\n"
        8.downto 1 do |r|
            row=r.to_s
            st+= Rainbow(row).color("FFFFFF")+"  "
            "a".upto "h" do |col|
                Game.position[[col,row]].nil? ? st+=Rainbow("  ").bg(@board[[col,row]]) : st+=Rainbow(Game.position[[col,row]].avatar+" ").bg(@board[[col,row]])
            end
            st+="\n"
        end
        st+= Rainbow("   a b c d e f g h").color("FFFFFF")
        st+="\n"

        #building the actual move list 
        mv=""
        Game.move_stack.each_with_index do |move,index|
            break if move==""
            nrmove=index/2+1
            index.even? ? (mv+=nrmove.to_s+". "+move) : mv+="  "+Rainbow(move).bright+"  "
            mv+="\n" if (index+1)%8==0
        end
        mv+="\n\n" if Game.move_stack != []

        mv+= Game.error if Game.error!="endgame"
        mv+= "\n"+ Game.status if Game.status!="game"
        puts st+"\n"+mv

        #end-game output
        # case Game.error
        # when "stalemate"
        #     mv+=" DRAW! "
        # when "repetition draw"
        #     mv+=" This position happened 3 times in the game! DRAW!"
        # when "end_mate"
        #     mv+=" CHECKMATE! WOW!"
        # when "endgame"
        #     Game.who_move=="B" ? mv+=" BLACK RESIGN!" : mv+= " WHITE RESIGN!"
        #     Game.status="end"
        # else
        #     mv+=Game.error
        # end
        # puts st+"\n"+mv
    end

    def getconsole
        Game.who_move=="W" ? (puts "White, make your move: ") : (puts "Black, make your move: ")
        actual_move=gets.chomp
        move=Move.new(actual_move)
    end

    def setup_board(variant="classic")
        #this method is the crossway for different variant setup. Here we have only one variant: classic
        return "Sorry, this variant is not (yet?) implemented" if variant!="classic"
        Game.position=setup_classic
    end

    def setup_classic
        game={}
        game[["a","1"]]=Rook.new(color: "W") #right white rook
        game[["b","1"]]=Knight.new(color: "W") #right white knight
        game[["c","1"]]=Bishop.new(color: "W") #right white bishop
        game[["d","1"]]=Queen.new(color: "W") #white queen
        game[["e","1"]]=King.new(color: "W") #white king
        game[["f","1"]]=Bishop.new(color: "W") #left white bishop
        game[["g","1"]]=Knight.new(color: "W") #left white knight
        game[["h","1"]]=Rook.new(color: "B") #left black rook
        game[["a","8"]]=Rook.new(color: "B") #right black rook
        game[["b","8"]]=Knight.new(color: "B")  #right black knight
        game[["c","8"]]=Bishop.new(color: "B")  #right black bishop
        game[["d","8"]]=Queen.new(color: "B")  #black queen
        game[["e","8"]]=King.new(color: "B")  #black king
        game[["f","8"]]=Bishop.new(color: "B")  #left black bishop
        game[["g","8"]]=Knight.new(color: "B")  #left black knight
        game[["h","8"]]=Rook.new(color: "B")  #left black rook
        "a".upto "h" do |col|
            game[[col,"2"]]=Pawn.new(color: "W") 
            game[[col,"7"]]=Pawn.new(color: "B") 
        end
        return game
    end
end                   


