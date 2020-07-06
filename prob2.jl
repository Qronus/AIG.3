# using Pkg; Pkg.add("https://github.com/QuantEcon/Games.jl")

#module beautifulmind 

using Games

#-----------------------------------------------------------------

# defines the simultaneous game
function init()

if "y" == uppercase(Int,query("\n*****Simultaneous games ****\n\n\t2.define own game?(y/n)\n\n\tchoice: "))
    mat = Array{Float64}(undef, 2, 2, 2)
    mat[1, 1, :] = [3, 2]  
    mat[1, 2, :] = [2, 2]
    mat[2, 1, :] = [2, 3]
    mat[2, 2, :] = [5, 0]
    sim = NormalFormGame(pennies)
    output(sim)
end



println("Defining own game\n")
    if 1 == parse(Int,query("choose input method\n\t1.by matrix\n\t2.by vector\n\n\tchoice: "))

        matrix = Array{Int}(undef, 2, 2, 2)
        for o in 1:2
            for i in 1:2
             
             str = query("Input values for row $o column $i e.g(2 5): ")
            matrix[o, i, :] =  [parse(Int,split(str," ")[1]), parse(Int,split(str," ")[2])]
    
            end
        end
        game = NormalFormGame(matrix)
        output(game)
    else

         p1 = [1 2 ; 3 4]
          str = replace(query("Input player1 strategies e.g(2 5;3 7): "),";" => "")
          str = replace(str," " => "")

          for (i,x) in enumerate(str)
             p1[i]=parse(Int,x)
          end 

        p1 = Player(p1)

         
          p2 = [1 2 ; 3 4]
          str = replace(query("Input player2 strategies e.g(2 5;3 7): "),";" => "")
          str = replace(str," " => "")

          for (i,x) in enumerate(str)
             p2[i]=parse(Int,x)
         end 

        p2 = Player(p2)

        game = NormalFormGame(p1,p2)
        output(game)
    end

  
end

#-----------------------------------------------------------------

function determineStrategy(game)

    best_responses(game.players[1], [0.5, 0.5])
   game.player1[1].

end

#-----------------------------------------------------------------

function output(game::NormalFormGame)
    equilibria = pure_nash(game)
    equilibriaNo = length(equilibria)

    if equilibriaNo == 0
        str = "no pure Nash equilibrium found"
    elseif equilibriaNo == 1
        str = "There is 1 equilibrium:\n$(equilibria[1])"
    else
        str = "There is $equilibriaNo  equilibria:\n"
        for (i, E) in enumerate(equilibria)
            i < equilibriaNo ? str *= "$E, " : str *= "$E"
        end
    end
    println(join(["\n",str]))
    return
end

#-----------------------------------------------------------------

function query(str::String)

    print(str);
   return input = readline();

end

#-----------------------------------------------------------------

init() #driver statement
#end #module