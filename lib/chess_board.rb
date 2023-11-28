# With this class we build the board and we produce the relative output
# we consider 3 different output: HTML, Console, Json
# In this first round of developing we work on console output
# For console, we use Rainbow gem for colorize the text

require "rainbow"
require_relative "king"
require_relative "bishop"
require_relative "rook"
require_relative "knight"
require_relative "queen"
require_relative "pawn"
require_relative "space"


class ChessBoard 
    attr_reader :status, :board, :start_position, :media
    
    WHITESPACECOLOR="6495ED"
    BLACKSPACECOLOR="00FFFF"
    def initialize(variant="classic",media="console",status="game")
        @media=media
        @status=status
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
        @start_position=setup_classic
    end

    def show_game(game, move_stack, status)
        case media
        when "console" then putconsole(game, move_stack, status)
        end
    end

    def take_move(n,err)
        case media
        when "console" then getconsole(n,err)
        end
    end

    def putconsole(game={},move_stack,status)
        #building the board as string
        st=""
        8.downto 1 do |r|
            row=r.to_s
            st+= Rainbow(row).color("FFFFFF")+"  "
            "a".upto "h" do |col|
                game[[col,row]].nil? ? st+=Rainbow("  ").bg(@board[[col,row]]) : st+=Rainbow(game[[col,row]].avatar+" ").bg(@board[[col,row]])
            end
            st+="\n"
        end
        st+= Rainbow("   a b c d e f g h").color("FFFFFF")
        st+="\n"

        #building the actual move list 
        mv=""
        move_stack.each_with_index do |move,index|
            break if move==""
            nrmove=index/2
            index.even? ? (mv+=nrmove.to_s+". "+move) : mv+="  "+Rainbow(move).bright+"  "
            mv+="\n" if (index+1)%8==0
        end
        mv+="\n\n" if move_stack != []

        #end-game output
        case status
        when "end_draw"
            mv+=" DRAW! "
        when "end_mate"
            mv+=" CHECKMATE!"
        when "end_resign"
            move_stack.size.odd? ? mv+=" BLACK RESIGN!" : mv+= " WHITE RESIGN!"
        end
        puts st+"\n"+mv
    end

    def getconsole(n,err)
        mv=""
        case err
        when "bad" then mv="Move is not recognized, retry \n"
        when "err" then mv="Move is not possible, retry \n"
        end
        n.size.odd? ? mv+="Nero Move!:" : mv+="White Move!:"
        puts mv+" "
        return gets
    end

    def setup_board(variant="classic")
        #this method is the crossway for different variant setup. Here we have only one variant: classic
        return "Sorry, this variant is not (yet?) implemented" if variant!="classic"
        @start_position=setup_classic
    end

    def setup_classic
        game={}
        game[["a","1"]]=Rook.new("W","a1") #right white rook
        game[["b","1"]]=Knight.new("W","b1") #right white knight
        game[["c","1"]]=Bishop.new("W","c1") #right white bishop
        game[["d","1"]]=Queen.new("W","d1") #white queen
        game[["e","1"]]=King.new("W","e1") #white king
        game[["f","1"]]=Bishop.new("W","f1") #left white bishop
        game[["g","1"]]=Knight.new("W","g1") #left white knight
        game[["h","1"]]=Rook.new("W","h1") #left black rook
        game[["a","8"]]=Rook.new("B","a8") #right black rook
        game[["b","8"]]=Knight.new("B","b8") #right black knight
        game[["c","8"]]=Bishop.new("B","c8") #right black bishop
        game[["d","8"]]=Queen.new("B","d8") #black queen
        game[["e","8"]]=King.new("B","e8") #black king
        game[["f","8"]]=Bishop.new("B","f8") #left black bishop
        game[["g","8"]]=Knight.new("B","g8") #left black knight
        game[["h","8"]]=Rook.new("B","h8") #left black rook
        "a".upto "h" do |col|
            game[[col,"2"]]=Pawn.new("W",col+"2")
            game[[col,"7"]]=Pawn.new("B",col+"7")
        end
        return game
    end
end                   


