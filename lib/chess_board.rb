# With this class we build the board and we produce the relative output
# we consider 3 different output: HTML, Console, Json
# In this first round of developing we work on console output
# For console, we use Rainbow gem for colorize the text

require "rainbow"

class ChessBoard 
    
    WHITESPACECOLOR="6495ED"
    BLACKSPACECOLOR="00FFFF"
    def initialize
        @board=Hash.new{}
        color=WHITESPACECOLOR
        "1".upto "8" do |r|
            row=r.to_s
            "a".upto "h" do |col|
                @board[[row,col]] = color
                color==WHITESPACECOLOR ? color=BLACKSPACECOLOR : color=WHITESPACECOLOR
            end
            color==WHITESPACECOLOR ? color=BLACKSPACECOLOR : color=WHITESPACECOLOR
        end
    end

    def putconsole (game={})
        st=""
        8.downto 1 do |r|
            row=r.to_s
            st+= Rainbow(row).color("FFFFFF")+"  "
            "a".upto "h" do |col|
                game[[row,col]].nil? ? 
                    st+=Rainbow("   ").bg(@board[[row,col]]) : 
                    st+=Rainbow(" "+game[[row,col]].avatar+" ").bg(@board[[row,col]])
            end
            st+="\n"
        end
        st+= Rainbow("    a  b  c  d  e  f  g  h").color("FFFFFF")
        puts st
    end
end                   


